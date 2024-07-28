extends Control
class_name JobUI

@export var job: Job
@export var emptyContainer: Container
@export var employeePos: Node2D
@export var storageContainer: Container
@export var inMarkers: Array[Marker2D]
@export var outMarkers: Array[Marker2D]
@export var choiceHighlight: Control

var dragOffset: Vector2
var dragged = false

signal moved

func _ready():
	if job != null and job.employee != null:
		addEmployee(job.employee)

	if job != null:
		Events.employeePlaced.connect(func(e,j): if j == job: scheduleAddEmployee(e))
		Events.employeeRemoved.connect(func(_e, j): if j == job: scheduleShowVacanat())
		
	Events.showChoices.connect(checkMyselfAsChoice)
	Events.stopShowChoices.connect(scheduleClearMyHighlight)
	Events.jobDragStart.connect(func(j): if j == self: startDrag())
	Events.jobDragEnd.connect(func(j): if j == self: endDrag())
	Events.jobDestroyed.connect(func(j): if j == job: scheduleDestroyJob())

func checkMyselfAsChoice(validator: Callable):
	# print("check myself as choice")
	if validator.call(self.job):
		choiceHighlight.visible = true
		#UIScheduler.addToSchedule(func(): choiceHighlight.visible = true)
	else:
		scheduleClearMyHighlight()

func scheduleClearMyHighlight():
	choiceHighlight.visible = false
	# UIScheduler.addToSchedule(func(): choiceHighlight.visible = false)

func scheduleAddEmployee(employee: Employee):
	UIScheduler.addToSchedule(addEmployee.bind(employee))

func scheduleShowVacanat():
	var curEmpUI = employeePos.get_children()
	if curEmpUI.size() >0:
		assert(curEmpUI[0] is EmployeeUI)
		curEmpUI[0].scheduleShowDestroy()
	UIScheduler.addToSchedule(showVacant)

func scheduleDestroyJob():
	UIScheduler.addToSchedule(queue_free)

func addEmployee(employee: Employee):
	#print('add employee triggered')
	emptyContainer.visible = false
	employeePos.add_child(EmployeeUILord.makeNewEmployeeUI(employee))

func showVacant():
	emptyContainer.visible = true

func startDrag():
	dragged = true
	dragOffset = get_viewport().get_mouse_position() - global_position
	#print('drag start')

func _process(_delta):
	if dragged:
		global_position = get_viewport().get_mouse_position() - dragOffset
		moved.emit()		

func endDrag():	
	dragged = false
	#print('drag ended')


func _on_drag_detect_area_input_event(_viewport:Node, event:InputEvent, _shape_idx:int):
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			Events.jobClicked.emit(self, event.button_index)
		elif event.is_released():
			Events.jobClickReleased.emit(self, event.button_index)
