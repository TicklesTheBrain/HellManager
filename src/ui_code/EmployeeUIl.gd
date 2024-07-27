extends Node
class_name EmployeeUI

@export var employee: Employee:
	set(v):
		employee = v
		updateVisuals()
@export var employeeNameLabel: Label
@export var prestigeLabel: Label
@export var capacityLabel: Label
@export var employeeTextLabel: Label
@export var employeePic: TextureRect
@export var requestMouseOver: bool
@export var destroyFadeTime: float

func _ready():
	if employee != null:
		updateVisuals()
		employee.prestigeChange.connect(updatePrestige)
		employee.capacityChange.connect(updateCapacity)
		employee.destroyed.connect(scheduleShowDestroy)

func updateVisuals():
	if employeeNameLabel != null:
		employeeNameLabel.text = employee.employeeName
	if employeeTextLabel != null:
		employeeTextLabel.text = employee.staticText
	if employeePic != null:
		employeePic.texture = employee.employeePic
	if prestigeLabel != null:
		prestigeLabel.text = str(employee.prestige)
	if capacityLabel != null:
		capacityLabel.text = str(employee.capacity)

func _mouse_exited():
	# print('emp UI mouse leave')
	Events.employeeUIMouseOverEnd.emit(self)

func _mouse_entered():
	# print('emp UI mouse enter')
	Events.employeeUIMouseOverStart.emit(self)

func updatePrestige():
	# print('update prestige called')
	var newPrestige = str(employee.prestige)
	UIScheduler.addToSchedule(func(): prestigeLabel.text = newPrestige)

func updateCapacity():
	var newCapacity = str(employee.capacity)
	UIScheduler.addToSchedule(func(): capacityLabel.text = newCapacity)

func showDestroy():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(Color.WHITE, 0), destroyFadeTime)
	await get_tree().create_timer(destroyFadeTime).timeout

func scheduleShowDestroy():
	UIScheduler.addToSchedule(showDestroy)