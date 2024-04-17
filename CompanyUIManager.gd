extends Node2D
class_name CompanyUILord

@export var lineUIPacked: PackedScene
@export var jobUIPacked: PackedScene
@export var employeeUIPacked: PackedScene
@export var jobManager: JobManager

@export var lineLayer: CanvasLayer
@export var jobLayer: CanvasLayer

@export var someVectors: Array[Vector2] = []


func _ready():
	Events.flowAdded.connect(addNewLineUI)
	Events.flowRemoved.connect(removeLineUI)
	Events.jobAdded.connect(makeNewJobUI)

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
	var newPos = someVectors.pop_front()
	newJobUI.position = newPos
	someVectors.push_back(newPos)
	jobLayer.add_child(newJobUI)

