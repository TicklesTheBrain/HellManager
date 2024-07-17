extends Node
class_name TaskManager

@export var taskHand: Hand
@export var taskDeck: Deck
@export var addTaskEveryXTurns: int = 5
var newTaskCounter: int = 0

func _ready():
    addNewTask()
    Events.phaseStarted.connect(func(p):
        if p == Globals.phases.CONSEQUENCE:
            applyConsequence()
            Events.phaseEnded.emit(Globals.phases.CONSEQUENCE)
        )

func addNewTask():
    var newTask = taskDeck.drawCard()
    taskHand.addCard(newTask)
    Events.newTaskAdded.emit(newTask)

func tickCounter():
    newTaskCounter += 1
    if newTaskCounter >= addTaskEveryXTurns:
        addNewTask()
        newTaskCounter = 0

func applyConsequence():
    print('applying consequences')
    taskHand.getAll().all(func(t): t.executeConsequence())


    