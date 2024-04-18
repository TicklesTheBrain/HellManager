extends Node

@export var employeeUIPacked: PackedScene
@export var employeeUIs: Array[EmployeeUI] = []

func _ready():
    Events.employeeConsumed.connect(func(e,_j): destroyEmployeeUI(e))     

func makeNewEmployeeUI(employee: Employee) -> EmployeeUI:
    var newUI = employeeUIPacked.instantiate()
    newUI.employee = employee
    employeeUIs.push_back(newUI)
    return newUI

func getEmployeeUI(employee: Employee) -> EmployeeUI:
    var matching = employeeUIs.filter(func(u): return u.employee == employee)
    if matching.size() == 0:
        return null
    else:
        return matching[0]

func destroyEmployeeUI(employee: Employee):
    var ui = getEmployeeUI(employee)
    if ui != null:
        ui.queue_free()
        employeeUIs.erase(ui)

