extends Node
class_name TaskManager

@export var taskHand: Hand
@export var taskDeck: Deck
@export var addTaskEveryXTurns: int = 5
var newTaskCounter: int = 0

func _ready():
    addNewTask()
    pass


func addNewTask():
    var newTask = taskDeck.drawCard()
    taskHand.addCard(newTask)
    Events.newTaskAdded.emit(newTask)

func tickCounter():
    newTaskCounter += 1
    if newTaskCounter >= addTaskEveryXTurns:
        addNewTask()
        newTaskCounter = 0


    