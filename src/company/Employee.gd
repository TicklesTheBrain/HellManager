extends Resource
class_name Employee

@export var prestige: int:
    set(v):
        if v != prestige:
            prestigeChange.emit()
        prestige = v
@export var capacity: int:
    set(v):
        if v != capacity:
            capacityChange.emit()
        capacity = v
@export var dependentActions: Array[Action] = []
@export var independentActions: Array[Action] = [] #TODO: I forgot why I put it here
@export var whenPlacedActions: Array[Action] = []
@export var methodReplacements: Array[MethodReplacement] = []
@export var employeeName: String
@export var employeePic: Texture2D
@export var staticText: String

signal prestigeChange
signal capacityChange
signal destroyed

func doWork(_job: Job):
    Events.employeeActivationStart.emit(self)

    if dependentActions.all(func(a): return a.try()):
        dependentActions.all(func(a): return a.perform())

    for action in independentActions:
        if action.try():
            action.perform()

    Events.employeeActivationEnd.emit(self)

func destroy():
    destroyed.emit()

func triggerPlaced():
    for action in whenPlacedActions:
        if action.try():
            action.perform()

func checkJobMethodReplacement(methodName: String):
    return methodReplacements.any(func(mr): return mr.has_method(methodName))

func findJobMethodReplacement(methodName: String):
    return methodReplacements.filter(func(mr): return mr.has_method(methodName))[0]

func invokeJobMethodReplacement(methodName: String, argArray: Array):
    if checkJobMethodReplacement(methodName):
        var mr = findJobMethodReplacement(methodName)
        var bound = mr[methodName].bindv(argArray)
        return bound.call()
    return false
    