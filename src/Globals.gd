extends Node

@export var phase: phases
@export var day: int = 0
@export var actingJob: Job
@export var actingEmployee: Employee
@export var actingCard: ProtoCard
@export var actionStack: Array[Action] = []
var stepCounter: int = 0

enum phases {
	MORNING,
	WORK,
	MANAGE,
	CONSEQUENCE
}

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

	#Manging game phase
	Events.phaseEnded.connect(func(p):
		if p == phases.WORK:
			Events.phaseStarted.emit(phases.CONSEQUENCE)
	)
	
	Events.phaseEnded.connect(func(p):
		if p == phases.CONSEQUENCE:
			
			Events.phaseStarted.emit(phases.MORNING)
			#Start phase will be where all the market setup and start of day conditions happen, will SETup later
			Events.phaseEnded.emit(phases.MORNING)
	)

	Events.phaseEnded.connect(func(p):
		if p == phases.MORNING:
			Events.phaseStarted.emit(phases.MANAGE)
	)

	Events.cardUseEnded.connect(func(_c):
		Events.phaseEnded.emit(phases.WORK)
		getJobManager().makeEveryoneWork()
	)

	Events.cardTaken.connect(func(_c):
		Events.phaseEnded.emit(phases.WORK)
		getJobManager().makeEveryoneWork()
	)

	#Manage days
	Events.phaseEnded.connect(func(p):
		if p == phases.CONSEQUENCE:
			Events.dayEnded.emit(day)
			Events.dayStarted.emit(day+1)
	)

	Events.dayStarted.connect(func(d):
		day = d
	)

	#Start first day
	Events.dayStarted.emit(day+1)

func _unhandled_input(event):
	if event.is_action_pressed("work"):
		getJobManager().makeEveryoneWork()		

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
