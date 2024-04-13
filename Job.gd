extends Node
class_name Job

@export var priority: int = 1
@export var inflow: Array[Job] = []
@export var employee: Employee
@export var storage: Dictionary

func doWork():
    if employee != null:
        employee.doWork(self)

func canFulfillRequest(_request: Dictionary) -> bool:
    return false




    

