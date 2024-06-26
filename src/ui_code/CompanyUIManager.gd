extends Node2D
class_name CompanyUILord

@export var jobManager: JobManager

@export_group("Packed Scenes")
@export var lineUIPacked: PackedScene
@export var jobUIPacked: PackedScene
@export var tokenUIPacked: PackedScene

@export_group("UI Layers")
@export var lineLayer: CanvasLayer
@export var jobLayer: CanvasLayer
@export var tokenLayer: CanvasLayer

@export_category("Grid stuff")
@export var gridCellSizeVector: Vector2
@export var gridGapSizeVector: Vector2
@export var gridSizeVector: Vector2

@export_category("Timing Stuff")
@export var tokenAppearTime: float = 0.4
@export var tokenMoveTime: float = 0.4
@export var tokenFadeTime: float = 0.3

var gridCells = {}
var tokenUIs = []

func _ready():

	createGrid()

	Events.flowAdded.connect(addNewLineUI)
	Events.flowRemoved.connect(removeLineUI)
	Events.jobAdded.connect(makeNewJobUI)
	Events.jobDragEnd.connect(dragJobToNewCell)
	Events.tokenProduced.connect(scheduleMakeNewToken)
	Events.tokenMoved.connect(scheduleMoveToken)
	Events.tokenConsumed.connect(scheduleConsumeToken)
	Events.tokenStored.connect(scheduleStoreToken)

	for job in jobManager.get_children():
		if getJobUI(job) == null:
			makeNewJobUI(job)
			for token in job.storage.contents:
				makeNewToken(token, job)

	for job in jobManager.get_children():
		for source in job.inflow:
			addNewLineUI(source, job)

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

func getLineUI(from: Job, to: Job) -> flowLineUI:
	for line in lineLayer.get_children():
		if line.from == from and line.to == to:
			return line
	return null

func getJobUI(job: Job) -> JobUI:
	for child in jobLayer.get_children():
		if child.job == job:
			return child
	return null

func makeNewJobUI(job: Job):
	var newJobUI = jobUIPacked.instantiate()
	newJobUI.job = job

	var newPos = findFirstEmpyGridCell()
	newJobUI.position = newPos
	gridCells[newPos] = newJobUI

	jobLayer.add_child(newJobUI)

func createGrid():
	
	var lineY = gridGapSizeVector.y + gridCellSizeVector.y/2
	var cellX = gridGapSizeVector.x + gridCellSizeVector.x/2
	var firstCellX = cellX

	#Check if new cell fits within grid
	while(lineY + gridCellSizeVector.y/2 < gridSizeVector.y and cellX + gridCellSizeVector.x/2 < gridSizeVector.x):
		while(lineY + gridCellSizeVector.y/2 < gridSizeVector.y and cellX + gridCellSizeVector.x/2 < gridSizeVector.x):
			gridCells[Vector2(cellX, lineY)] = null
			cellX += gridCellSizeVector.x + gridGapSizeVector.x
		cellX = firstCellX
		lineY += gridCellSizeVector.y + gridGapSizeVector.y

func findFirstEmpyGridCell():
	for cell in gridCells.keys():
		if gridCells[cell] == null:
			return cell
	return null

func findJobUICell(jobUi: JobUI):
	for cell in gridCells.keys():
		if gridCells[cell] == jobUi:
			return cell
	return null

func findClosestEmptyCell(pos: Vector2):
	var emptyCells = getAllEmptyCells()
	if emptyCells.size() == 0:
		return
	var closest = emptyCells[0]	
	for cell in emptyCells:
		if abs(pos - cell) < abs(pos - closest):
			closest = cell
	return closest

func getAllEmptyCells():
	return gridCells.keys().filter(func(v): return gridCells[v] == null)

func dragJobToNewCell(jobUI: JobUI):
	gridCells[findJobUICell(jobUI)] = null
	var closest = findClosestEmptyCell(get_viewport().get_mouse_position())
	gridCells[closest] = jobUI
	jobUI.global_position = closest
	jobUI.moved.emit()

func makeNewToken(token: Token, job: Job):
	var newToken = tokenUIPacked.instantiate()
	tokenUIs.push_back(newToken)
	newToken.token = token
	var jobProducing = getJobUI(job)
	jobProducing.storageContainer.add_child(newToken)
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
		print('previous pos ', previousPos)
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
	var tween = get_tree().create_tween()
	tween.tween_property(tokenUI, "scale", Vector2(0,0), tokenFadeTime)
	await tween.finished
	tokenUI.free()

func storeToken(t: Token, j: Job):
	var tokenUI = getTokenUI(t)
	tokenUI.get_parent().remove_child(tokenUI)
	var jobUI = getJobUI(j)
	jobUI.storageContainer.add_child(tokenUI)
