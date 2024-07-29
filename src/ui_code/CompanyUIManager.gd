extends Node2D
class_name CompanyUILord

@export var jobManager: JobManager
@export var companyCanvas: CompanyUICanvas

@export_group("Packed Scenes")
@export var lineUIPacked: PackedScene
@export var jobUIPacked: PackedScene
@export var tokenUIPacked: PackedScene
@export var gridCell: PackedScene

@export_group("UI Layers")
@export var lineLayer: CanvasLayer
@export var jobLayer: CanvasLayer
@export var tokenLayer: CanvasLayer
@export var cellLayer: CanvasLayer

@export_category("Grid stuff")
@export var gridGapSizeVector: Vector2
@export var minimumRows: int
@export var minimumColumns: int
@export var initialRowMax: int

@export_category("Timing Stuff")
@export var tokenAppearTime: float = 0.4
@export var tokenMoveTime: float = 0.4
@export var tokenFadeTime: float = 0.3

var gridCellSizeVector: Vector2
var gridCells = []
var tokenUIs = []
var draggedJob: JobUI = null
var dragTarget: CompanyGridCell = null:
	set(v):
		dragTarget = v

		if dragTarget == null:
			for cell in getAllCells():
				cell.highlightOff()
			return

		if not dragTarget.highlight:
			for cell in getAllCells():
				cell.highlightOff()
			dragTarget.highlightOn()
			return

func _ready():

	gridCellSizeVector = gridCell.instantiate().getSize()
	createGrid()

	Events.flowAdded.connect(addNewLineUI)
	Events.flowRemoved.connect(removeLineUI)
	Events.jobAdded.connect(makeNewJobUI)
	Events.jobDragStart.connect(startJobDrag)
	Events.jobDragEnd.connect(dragJobToNewCell)
	Events.tokenProduced.connect(scheduleMakeNewToken)
	Events.tokenMoved.connect(scheduleMoveToken)
	Events.tokenConsumed.connect(scheduleConsumeToken)
	Events.tokenStored.connect(scheduleStoreToken)

	for job in jobManager.get_children():
		if getJobUI(job) == null:
			makeNewJobUI(job, true)
			for token in job.storage.contents:
				makeNewToken(token, job)

	for job in jobManager.get_children():
		for source in job.inflow:
			addNewLineUI(source, job)

	updateCanvas()

func showGrid():
	for cell in getAllCells():
		cell.gridOn()

func hideGrid():
	for cell in getAllCells():
		cell.gridOff()

func startJobDrag(jobUI: JobUI):
	draggedJob = jobUI
	showGrid()

func scheduleMakeNewToken(token: Token, job: Job):
	UIScheduler.addToSchedule(makeNewToken.bind(token, job), token)

func scheduleMoveToken(token: Token, from: Job, to: Job):
	UIScheduler.addToSchedule(moveToken.bind(token, from, to), token)

func scheduleConsumeToken(token:Token):
	UIScheduler.addToSchedule(consumeToken.bind(token), token)

func scheduleStoreToken(token: Token, job: Job):
	UIScheduler.addToSchedule(storeToken.bind(token,job), token)

func addNewLineUI(from: Job, to: Job):
	if getLineUI(from, to) == null:
		var newLine = lineUIPacked.instantiate()
		newLine.from = from
		newLine.to = to
		newLine.fromUI = getJobUI(from)
		newLine.toUI = getJobUI(to)
		lineLayer.add_child(newLine)

func removeLineUI(from: Job, to: Job):
	getLineUI(from, to).free()

func getLineUI(from: Job, to: Job) -> FlowLineUI:
	for line in lineLayer.get_children():
		if line.from == from and line.to == to:
			return line
	return null

func getJobUI(job: Job) -> JobUI:
	for child in jobLayer.get_children():
		if child.job == job:
			return child
	return null

func makeNewJobUI(job: Job, fitIntoInitial: bool = false):
	var newJobUI = jobUIPacked.instantiate()
	newJobUI.job = job
	var emptyCell = null
	if fitIntoInitial:
		for row in gridCells:
			if emptyCell != null: break
			for i in range(row.size()):
				if i < initialRowMax and row[i].jobUI == null:
					emptyCell = row[i]
					break

	if emptyCell == null:
		emptyCell = findFirstEmpyGridCell()
	
	newJobUI.position = emptyCell.position
	emptyCell.jobUI = newJobUI

	jobLayer.add_child(newJobUI)

	if not fitIntoInitial:
		updateEmptyGridCells()

func updateCanvas():
	companyCanvas.makeSize(getGridSize())

func updateEmptyGridCells():

	var previousSize = getGridSize()

	while (true):
		var lastColumnCells = gridCells.map(func(r): return r[r.size()-1])
		if lastColumnCells.any(func(c): return c.jobUI != null) or gridCells[0].size() < minimumColumns:
			addNewColumnToGrid()
			continue
		if gridCells[0].size() > 1:
			var penultimateColumnsCells = gridCells.map(func(r): return r[r.size()-2])
			if penultimateColumnsCells.all(func(c): return c.jobUI == null) and gridCells[0].size() > minimumColumns:
				removeColumnFromGrid()
				continue
		break

	while (true):
		var lastRowCells = gridCells[gridCells.size()-1]
		if lastRowCells.any(func(c): return c.jobUI != null) or gridCells.size() < minimumRows:
			addNewRowToGrid()
			continue

		if gridCells.size() > 1:
			var penultimateRowCells = gridCells[gridCells.size()-2]
			if penultimateRowCells.all(func(c): return c.jobUI == null) and gridCells.size() > minimumRows:
				removeRowFromGrid()
				continue

		break

	if previousSize != getGridSize():
		updateCanvas()

func getGridSize() -> Vector2:
	return Vector2(gridCells[0].size()*(gridCellSizeVector.x+gridGapSizeVector.x)+gridGapSizeVector.x,
	 gridCells.size()*(gridCellSizeVector.y+gridGapSizeVector.y)+gridGapSizeVector.y)

func createGrid():

	#Let's add a single cell to start us off
	var lineY = gridGapSizeVector.y + gridCellSizeVector.y/2
	var cellX = gridGapSizeVector.x + gridCellSizeVector.x/2
	var cell = makeNewGridCell()
	cell.position = Vector2(cellX, lineY)
	gridCells.push_back([cell])
	
	for r in range(minimumRows-1):
		addNewRowToGrid()
	
	for c in range(minimumColumns-1):
		addNewColumnToGrid()	

func addNewColumnToGrid():

	for row in gridCells:
		var lastCellPos = row[row.size()-1].position
		var newCell = makeNewGridCell()
		newCell.position = Vector2(lastCellPos.x + gridGapSizeVector.x + gridCellSizeVector.x, lastCellPos.y)
		row.push_back(newCell)

func addNewRowToGrid():

	var startX = gridGapSizeVector.x + gridCellSizeVector.x/2
	var lineY = gridCells[gridCells.size()-1][0].position.y + gridGapSizeVector.y + gridCellSizeVector.y
	var amountOfColumns = gridCells[0].size()
	var newRow = []
	for i in range(amountOfColumns):
		var newCell = makeNewGridCell()
		newCell.position = Vector2(startX +  i * (gridGapSizeVector.x + gridCellSizeVector.x), lineY)
		newRow.push_back(newCell)
	gridCells.push_back(newRow)	

func removeRowFromGrid():

	var row = gridCells[gridCells.size()-1]
	for cell in row:
		cell.queue_free()
	gridCells.erase(row)

func removeColumnFromGrid():

	for row in gridCells:
		var cell = row[row.size()-1]
		cell.queue_free()
		row.erase(cell)

func makeNewGridCell():
	var cell = gridCell.instantiate()
	cellLayer.add_child(cell)
	return cell

func findFirstEmpyGridCell():

	for row in gridCells:
		for cell in row:
			if cell.jobUI == null:
				return cell
	return null

func findJobUICell(jobUi: JobUI):
	for row in gridCells:
		for cell in row:
			if cell.jobUI == jobUi:
				return cell
	return null

func findClosestEmptyCell(pos: Vector2):
	var emptyCells = getAllEmptyCells()
	if emptyCells.size() == 0:
		return
	var closest = emptyCells[0]
	for cell in emptyCells:
		if abs(pos - cell.position) < abs(pos - closest.position):
			closest = cell
	return closest

func findClosestCell(pos: Vector2):
	var closest = gridCells[0][0]
	for cell in getAllCells():
		if abs(pos - cell.position) < abs(pos - closest.position):
			closest = cell
	return closest

func getAllEmptyCells():
	return getAllCells().filter(func(c): return c.jobUI == null)

func getAllCells():
	return gridCells.reduce(func(acc, r):
		acc.append_array(r)
		return acc,
		[]
	)

func dragJobToNewCell(jobUI: JobUI):
	var oldCell = findJobUICell(jobUI)

	if dragTarget == null:
		jobUI.position = oldCell.position
	else:
		dragTarget.jobUI = jobUI
		oldCell.jobUI = null
		jobUI.position = dragTarget.position
		dragTarget = null

	draggedJob = null
	jobUI.moved.emit()
	updateEmptyGridCells()
	hideGrid()

func makeNewToken(token: Token, job: Job):
	var newToken = tokenUIPacked.instantiate()
	tokenUIs.push_back(newToken)
	newToken.token = token
	storeToken(token, job)
	await get_tree().process_frame
	newToken.scale = Vector2(0,0)
	var tween = get_tree().create_tween()
	tween.tween_property(newToken,"scale", Vector2(1,1), tokenAppearTime)
	await tween.finished

func getTokenUI(token: Token) -> TokenUI:
	for ui in tokenUIs:
		if ui.token == token:
			return ui
	return null

func moveToken(token: Token, from: Job, to: Job):
	var tokenUI = getTokenUI(token)
	if tokenUI.get_parent() is Container:
		var previousPos = tokenUI.global_position
		tokenUI.get_parent().remove_child(tokenUI)
		#print('previous pos ', previousPos)
		tokenUI.position = previousPos
		tokenLayer.add_child(tokenUI)
	var line = getLineUI(from, to)
	var tween = get_tree().create_tween()
	tween.tween_property(tokenUI,"global_position", line.points[0], tokenMoveTime)
	await tween.finished
	tween = get_tree().create_tween()
	tween.tween_property(tokenUI,"global_position", line.points[1], tokenMoveTime)
	await tween.finished

func consumeToken(t: Token):
	var tokenUI = getTokenUI(t)
	tokenUIs.erase(tokenUI)
	#print('token ', t, ' tokenUI ', tokenUI)
	var tween = get_tree().create_tween()
	tween.tween_property(tokenUI, "scale", Vector2(0,0), tokenFadeTime)
	await tween.finished
	if is_instance_valid(tokenUI):
		tokenUI.queue_free()

func storeToken(t: Token, j: Job):
	var tokenUI = getTokenUI(t)
	var parent = tokenUI.get_parent()
	if parent != null:
		tokenUI.get_parent().remove_child(tokenUI)
	var jobUI = getJobUI(j)
	jobUI.storageContainer.add_child(tokenUI)

func _process(_delta):

	if draggedJob != null:
		var allCells = getAllCells()
		var sortCellsByDistance = func(a, b):
			return abs(a.position - draggedJob.position) < abs(b.position - draggedJob.position)
		allCells.sort_custom(sortCellsByDistance)
		allCells = allCells.filter(func(c): return c.jobUI != draggedJob)
		if allCells[0].jobUI == null:
			dragTarget = allCells[0]
		else:
			dragTarget = null

	

