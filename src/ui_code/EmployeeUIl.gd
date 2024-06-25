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

func _ready():
	if employee != null:
		updateVisuals()

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
