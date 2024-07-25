extends Node
class_name TaskManager

@export var taskHand: Hand
@export var taskDeck: Deck
@export var addTaskEveryXTurns: int = 5
@export var startingTasks: int = 0
var newTaskCounter: int = 0

func _ready():
    addNewTasks(startingTasks)   

func addNewTasks(amount: int):
    for i in range(amount):
        var newTask = taskDeck.drawCard()
        newTask.resetFrequency()
        taskHand.addCard(newTask)
        Events.newTaskAdded.emit(newTask)

func tickCounter():
    newTaskCounter += 1
    if newTaskCounter >= addTaskEveryXTurns:
        addNewTasks(1)
        newTaskCounter = 0

func processConsequence():
    #print('applying consequences')
    taskHand.getAll().all(func(t):
        t.tickConsequence()
        return true
    )
    tickCounter()


    