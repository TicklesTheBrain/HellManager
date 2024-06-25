extends Node2D
class_name CompanyUILord

@export var lineUIPacked: PackedScene
@export var jobUIPacked: PackedScene
@export var jobManager: JobManager
@export var lineLayer: CanvasLayer
@export var jobLayer: CanvasLayer

@export_category("Grid stuff")
@export var gridCellSizeVector: Vector2
@export var gridGapSizeVector: Vector2
@export var gridSizeVector: Vector2
var gridCells = {}


func _ready():

	createGrid()

	Events.flowAdded.connect(addNewLineUI)
	Events.flowRemoved.connect(removeLineUI)
	Events.jobAdded.connect(makeNewJobUI)
	Events.jobDragEnd.connect(dragJobToNewCell)

	for job in jobManager.get_children():
		if getJobUI(job) == null:
			makeNewJobUI(job)

	for job in jobManager.get_children():
		for source in job.inflow:
			addNewLineUI(source, job)

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



	


