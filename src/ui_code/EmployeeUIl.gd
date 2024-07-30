extends Node
class_name EmployeeUI

@export var employee: Employee:
	set(v):
		employee = v
		updateVisuals()
@export var employeeNameLabel: Label
@export var prestigeLabel: Label
@export var skillLabel: Label
@export var employeeTextLabel: Label
@export var employeePic: TextureRect
@export var requestMouseOver: bool
@export var destroyFadeTime: float

func _ready():
	if employee != null:
		updateVisuals()
		employee.prestigeChange.connect(updatePrestige)
		employee.skillChange.connect(updateSkill)
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
	if skillLabel != null:
		skillLabel.text = str(employee.skill)

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

func updateSkill():
	var newSkill = str(employee.skill)
	UIScheduler.addToSchedule(func(): skillLabel.text = newSkill)

func showDestroy():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(Color.WHITE, 0), destroyFadeTime)
	await get_tree().create_timer(destroyFadeTime).timeout

func scheduleShowDestroy():
	UIScheduler.addToSchedule(showDestroy)