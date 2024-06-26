extends Control
class_name JobUI

@export var job: Job
@export var emptyContainer: Container
@export var employeePos: Node2D
@export var storageContainer: Container
@export var inMarkers: Array[Marker2D]
@export var outMarkers: Array[Marker2D]

var dragOffset: Vector2
var dragged = false

signal moved

func _ready():
	if job != null and job.employee != null:
		addEmployee(job.employee)

	if job != null:
		Events.employeePlaced.connect(func(e,j): if j == job: addEmployee(e))
		Events.employeeFired.connect(func(_e, j): if j == job: showVacant())
		Events.employeeConsumed.connect(func(_e, j): if j == job: showVacant())

	Events.jobDragStart.connect(func(j): if j == self: startDrag())
	Events.jobDragEnd.connect(func(j): if j == self: endDrag())		

func addEmployee(employee: Employee):
	print('add employee triggered')
	emptyContainer.visible = false
	employeePos.add_child(EmployeeUILord.makeNewEmployeeUI(employee))

func showVacant():
	emptyContainer.visible = true
	
func _on_job_frame_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			Events.jobClicked.emit(self, event.button_index)
		elif event.is_released():
			Events.jobClickReleased.emit(self, event.button_index)

func startDrag():
	dragged = true
	dragOffset = get_viewport().get_mouse_position() - global_position
	#print('drag start')

func _process(_delta):
	if dragged:
		global_position = get_viewport().get_mouse_position() + dragOffset
		moved.emit()		

func endDrag():	
	dragged = false
	#print('drag ended')
