extends Resource
class_name Card

@export var cardName: String
@export var employee: Employee:
    get:
        var employeeInActions = onExecute.filter(func(a): return a is ActionPlaceEmployee)
        if employeeInActions.size() > 0:
            return employeeInActions[0].employee
        return employee
       
@export var cardText: String
@export var onExecute: Array[Action]
@export var revealed: bool = false

