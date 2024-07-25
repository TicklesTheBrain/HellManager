extends ProtoCard
class_name TaskCard

@export var taskIcon: Texture
@export var taskText: String
@export var consequenceText: String
@export var taskConsequence: Array[Action]
#@export var onExecute: Array[Action] #Task Complete Actions, inherited
@export var consequenceFrequency: int = 0 #Zero means do it every consequence

signal timerChanged(newValue: int)

var frequencyTimer: int:
	# get:
	# 	if first:
	# 		first = false
	# 		return consequenceFrequency
	# 	return frequencyTimer
	set(v):
		#print('timer changed ', v)
		timerChanged.emit(v)
		frequencyTimer = v

func tickConsequence():
	#print('frequencyTimer ', frequencyTimer)
	if frequencyTimer <= 0:
		executeConsequence()		
		frequencyTimer = consequenceFrequency
	else:
		frequencyTimer -= 1

func specificDuplicate():
	var dupe = duplicate(true)
	dupe.onExecute.assign(onExecute.map(func(a): return a.duplicate(true) as Action) as Array[Action])
	dupe.taskConsequence.assign(taskConsequence.map(func(a): return a.duplicate(true) as Action) as Array[Action])
	return dupe

func postExecuteSpecific():
	Events.taskCompleted.emit(self)

func executeConsequence():
	Events.taskConsequenceStart.emit(self)
	taskConsequence.all(func(a): return a.perform())
	Events.taskConsequenceEnd.emit(self)

func resetFrequency():
	frequencyTimer = consequenceFrequency
