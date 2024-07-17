extends ProtoCard
class_name TaskCard

@export var taskIcon: Texture
@export var taskText: String
@export var consequenceText: String
@export var taskConsequence: Array[Action]
#@export var onExecute: Array[Action] #Task Complete Actions, inherited

func executeConsequence():
	Events.taskConsequenceStart.emit(self)
	taskConsequence.all(func(a): return a.perform())
	Events.taskConsequenceEnd.emit(self)

func specificDuplicate():
	var dupe = duplicate(true)
	dupe.onExecute.assign(onExecute.map(func(a): return a.duplicate(true) as Action) as Array[Action])
	dupe.taskConsequence.assign(taskConsequence.map(func(a): return a.duplicate(true) as Action) as Array[Action])
	return dupe

func postExecuteSpecific():
	Events.taskCompleted.emit(self)
