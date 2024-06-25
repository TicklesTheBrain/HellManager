extends Control
class_name JobUI

@export var job: Job
@export var emptyContainer: Container
@export var employeePos: Node2D
@export var storageContainer: Container
@export var tokenUIPacked: PackedScene
@export var inMarkers: Array[Marker2D]
@export var outMarkers: Array[Marker2D]

@export var tokenFadeTime: float = 0.2

var dragOffset: Vector2
var dragged = false

signal moved

func _ready():
	if job != null and job.employee != null:
		addEmployee(job.employee)

	if job != null and job.storage != null:
		Events.tokenProduced.connect(func(t,s): if s == job.storage: UIScheduler.addToSchedule(addTokenUI.bind(t)))
		Events.tokenConsumed.connect(func(t,s): if s == job.storage: UIScheduler.addToSchedule(removeTokenUI.bind(t)))
		for token in job.storage.contents:
			addTokenUI(token)

	if job != null:
		Events.employeePlaced.connect(func(e,j): if j == job: addEmployee(e))
		Events.employeeFired.connect(func(_e, j): if j == job: showVacant())
		Events.employeeConsumed.connect(func(_e, j): if j == job: showVacant())

	Events.jobDragStart.connect(func(j): if j == self: startDrag())
	Events.jobDragEnd.connect(func(j): if j == self: endDrag())		

func addTokenUI(t: Token):
	var newToken = tokenUIPacked.instantiate()
	newToken.type = t.type
	storageContainer.add_child(newToken)
	await get_tree().process_frame
	newToken.scale = Vector2(0,0)
	#print('new token scale ', newToken.scale, Time.get_ticks_msec())
	var tween = get_tree().create_tween()
	tween.tween_property(newToken,"scale", Vector2(1,1), tokenFadeTime)
	await tween.finished
	#print('new token scale ', newToken.scale, Time.get_ticks_msec())

func removeTokenUI(token: Token):
	var matching = storageContainer.get_children().filter(func(t): return t.type == token.type and not t.markedForConsumption)
	if matching.size() > 0:
		matching[0].markedForConsumption = true
		var tween = get_tree().create_tween()
		tween.tween_property(matching[0], "scale", Vector2(0,0), tokenFadeTime)
		await tween.finished
		matching[0].free()

func addEmployee(employee: Employee):
	print('add employee triggered')
	emptyContainer.visible = false
	employeePos.add_child(EmployeeUILord.makeNewEmployeeUI(employee))

func showVacant():
	emptyContainer.visible = true
	
func _on_job_frame_gui_input(event):
	#print('on job frame gui input')
	if event is InputEventMouseButton:
		if event.is_pressed():
			Events.jobClicked.emit(self, event.button_index)
		elif event.is_released():
			Events.jobClickReleased.emit(self, event.button_index)

func startDrag():
	dragged = true
	dragOffset = get_viewport().get_mouse_position() - global_position
	print('drag start')

func _process(_delta):
	if dragged:
		global_position = get_viewport().get_mouse_position() + dragOffset
		moved.emit()		

func endDrag():	
	
	dragged = false
	print('drag ended')
