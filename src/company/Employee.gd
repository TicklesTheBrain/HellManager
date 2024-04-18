extends Resource
class_name Employee

@export var prestige: int
@export var capacity: int
@export var dependentActions: Array[Action] = []
@export var independentActions: Array[Action] = []
@export var employeeName: String
@export var employeePic: Texture2D
@export var staticText: String

func doWork(_job: Job):
    Events.employeeActivationStart.emit(self)
    if dependentActions.all(func(a): return a.try()):
        dependentActions.all(func(a): return a.perform())
    Events.employeeActivationEnd.emit(self)