extends Node2D

@export var deck: Deck
@export var hand: CardContainer
@export var cardMarket: CardMarket
@export var jobManager: JobManager
@export var taskManager: TaskManager

@export var actionsPerManage: int = 3
var actionCounter: int = 0:
	set(v):
		Globals.actionCounter = v
		actionCounter = v
		if actionCounter > 0:
			Events.requestMessage.emit('Play a card, get a card or skip. Actions Left: {act}'.format({"act": actionCounter}), get_instance_id())

signal manageComplete

func _ready():
	Events.cardTaken.connect(markActionTaken)
	Events.cardUseEnded.connect(markActionTaken)
	mainLoop()

func markActionTaken(_discardedArgument, cost: int = 1):
	actionCounter -= cost
	if actionCounter <= 0:
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
	actionCounter = actionsPerManage
	
	await manageComplete #TODO: BAD BAD NOT GOOD, the idea is to create an action scheduler similar to the UIScheduler to make sure, things triggered off other events happen in the correct order
	await RenderingServer.frame_post_draw
	Events.clearMessage.emit( get_instance_id())
	Events.phaseEnded.emit(Globals.phases.MANAGE)
	Events.phaseStarted.emit(Globals.phases.WORK)
	jobManager.makeEveryoneWork()
	Events.phaseEnded.emit(Globals.phases.WORK)
	Events.phaseStarted.emit(Globals.phases.CONSEQUENCE)
	taskManager.processConsequence()
	Events.phaseEnded.emit(Globals.phases.CONSEQUENCE)
	Events.dayEnded.emit(Globals.day)
	mainLoop()

