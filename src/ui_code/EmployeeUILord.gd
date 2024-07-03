extends Node

@export var employeeUIPacked: PackedScene
@export var employeeUIPackedBig: PackedScene
#@export var employeeUIs: Array[EmployeeUI] = []

#func _ready():
	#Events.employeeConsumed.connect(func(e,_j): destroyEmployeeUI(e))     

func makeNewEmployeeUI(employee: Employee, big: bool = false) -> EmployeeUI:
	var newUI
	if big:
		newUI = employeeUIPackedBig.instantiate()
	else:
		newUI = employeeUIPacked.instantiate()
	newUI.employee = employee
	return newUI

# func getEmployeeUI(employee: Employee) -> EmployeeUI:
# 	var matching = employeeUIs.filter(func(u): return u.employee == employee)
# 	if matching.size() == 0:
# 		return null
# 	else:
# 		return matching[0]

# func destroyEmployeeUI(employee: Employee):
# 	var ui = getEmployeeUI(employee)
# 	if ui != null:
# 		ui.queue_free()
# 		employeeUIs.erase(ui)

