extends Node2D

@export var deck: Deck
@export var hand: CardContainer
@export var cardMarket: CardMarket
@export var jobManager: JobManager
@export var taskManager: TaskManager

signal manageComplete

func _ready():
	Events.cardTaken.connect(indicateManageComplete)
	Events.cardUseEnded.connect(indicateManageComplete)
	mainLoop()

func indicateManageComplete(_discardedArgument):
	manageComplete.emit()

func _unhandled_input(event):
	if event.is_action_pressed("draw"):
		if not deck.checkEmpty() and not hand.checkFull():
			hand.addCard(deck.drawCard())
	elif event.is_action_pressed("work"):
		manageComplete.emit()

func mainLoop():
	Events.dayStarted.emit(Globals.day+1)
	Events.phaseStarted.emit(Globals.phases.MORNING)
	cardMarket.refreshMarket()
	Events.phaseEnded.emit(Globals.phases.MORNING)
	Events.phaseStarted.emit(Globals.phases.MANAGE)
	await manageComplete
	Events.phaseEnded.emit(Globals.phases.MANAGE)
	Events.phaseStarted.emit(Globals.phases.WORK)
	jobManager.makeEveryoneWork()
	Events.phaseEnded.emit(Globals.phases.WORK)
	Events.phaseStarted.emit(Globals.phases.CONSEQUENCE)
	taskManager.processConsequence()
	Events.phaseEnded.emit(Globals.phases.CONSEQUENCE)
	Events.dayEnded.emit(Globals.day)
	mainLoop()