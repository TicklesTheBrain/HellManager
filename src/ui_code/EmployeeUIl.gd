extends Control
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
	employeeNameLabel.text = employee.employeeName
	employeeTextLabel.text = employee.staticText
	employeePic.texture = employee.employeePic
	prestigeLabel.text = str(employee.prestige)
	capacityLabel.text = str(employee.capacity)
