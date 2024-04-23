extends Node

@export var phase: int
@export var turn: int
@export var actingJob: Job
@export var actingEmployee: Employee
@export var actingGoal: int
@export var actingCard: Card
@export var actionStack: Array[Action] = []
var stepCounter: int = 0


func _ready():
	Events.phaseStarted.connect(func(p):
		phase = p
		stepCounter += 1)
	Events.phaseEnded.connect(func(_p): phase = -1)
	Events.turnStarted.connect(func(t):
		turn = t
		stepCounter +=1)
	Events.turnEnded.connect(func(_t): turn = -1)
	Events.jobStarted.connect(func(j):
		actingJob = j
		stepCounter +=1)
	Events.jobEnded.connect(func(_j): actingJob = null)
	Events.employeeActivationStart.connect(func(e):
		actingEmployee = e
		stepCounter +=1)
	Events.employeeActivationEnd.connect(func(_e): actingEmployee = null)
	Events.goalActivationStart.connect(func(g):
		actingGoal = g
		stepCounter +=1)
	Events.goalActivationEnd.connect(func(_g): actingGoal = -1)
	Events.cardUseStarted.connect(func(c):
		actingCard = c
		stepCounter +=1)
	Events.cardUseEnded.connect(func(_c): actingCard = null)
	Events.actionStarted.connect(func(a):
		actionStack.push_back(a)
		stepCounter +=1)
	Events.actionEnded.connect(func(a): actionStack.erase(a))

func getCtxt() -> GameContext:
	var ctxt = GameContext.new()
	ctxt.actingCard = actingCard
	ctxt.actingEmployee = actingEmployee
	ctxt.actingCard = actingCard
	ctxt.currentPhase = phase
	ctxt.currentTurn = turn
	ctxt.actingJob = actingJob
	ctxt.actingGoal = actingGoal
	ctxt.actionStack = actionStack.duplicate()
	ctxt.step = stepCounter
	return ctxt

func getJobManager() -> JobManager:
	return get_tree().get_first_node_in_group("JobLord")
