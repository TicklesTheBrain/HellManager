extends Node

@export var phase: phases:
	set(v):
		phase = v
		print('new phase ', v)
@export var day: int = 0
@export var actingJob: Job
@export var actingEmployee: Employee
@export var actingCard: ProtoCard
@export var actionStack: Array[Action] = []
var stepCounter: int = 0

enum phases {
	MORNING,
	MANAGE,
	WORK,	
	CONSEQUENCE
}

@export var marketOpen: bool = false
@export var slideInProgress: bool = false

func _ready():	
	
	#Keeping track of phase, step, etc.
	Events.phaseStarted.connect(func(p):
		phase = p
		stepCounter += 1)
	Events.phaseEnded.connect(func(_p): phase = -1) #TODO: FIX
	Events.dayStarted.connect(func(t):
		day = t
		stepCounter +=1)
	Events.dayEnded.connect(func(_t): day = -1)
	Events.jobStarted.connect(func(j):
		actingJob = j
		stepCounter +=1)
	Events.jobEnded.connect(func(_j): actingJob = null)
	Events.employeeActivationStart.connect(func(e):
		actingEmployee = e
		stepCounter +=1)
	Events.employeeActivationEnd.connect(func(_e): actingEmployee = null)
	Events.taskConsequenceStart.connect(func(g):
		actingCard = g
		stepCounter +=1)
	Events.taskConsequenceEnd.connect(func(_g): actingCard = null)
	Events.cardUseStarted.connect(func(c):
		actingCard = c
		stepCounter +=1)
	Events.cardUseEnded.connect(func(_c): actingCard = null)
	Events.actionStarted.connect(func(a):
		actionStack.push_back(a)
		stepCounter +=1)
	Events.actionEnded.connect(func(a): actionStack.erase(a))
	
	#Manage days
	Events.dayStarted.connect(func(d):
		day = d
	)


func getCtxt() -> GameContext:
	var ctxt = GameContext.new()
	ctxt.actingCard = actingCard
	ctxt.actingEmployee = actingEmployee
	ctxt.actingCard = actingCard
	ctxt.currentPhase = phase
	ctxt.currentTurn = day
	ctxt.actingJob = actingJob
	ctxt.actionStack = actionStack.duplicate()
	ctxt.step = stepCounter
	ctxt.playerData = getPlayerData()
	return ctxt

func getJobManager() -> JobManager:
	return get_tree().get_first_node_in_group("JobLord")

func getPlayerData():
	return get_tree().get_first_node_in_group("PlayerData")

func subtractTokenList(first, second):
	var result = first.duplicate()
	for token in second:
		var matching = result.filter(func(t): return t.type == token.type)
		if matching.size() > 0:
			result.erase(matching[0])
	return result
