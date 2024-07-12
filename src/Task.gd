extends Resource
class_name Task

@export var taskName: String
@export var taskIcon: Texture
@export var taskText: String
@export var consequenceText: String
@export var taskConsequence: Array[Action]
@export var taskActions: Array[Action]

func nonStupidDeepDuplicate() -> Task:
	var dupe = duplicate(true)
	dupe.taskConsequence.assign(taskConsequence.map(func(a): return a.duplicate(true) as Action) as Array[Action])
	dupe.taskActions.assign(taskActions.map(func(a): return a.duplicate(true) as Action) as Array[Action])
	return dupe

func startConsequence():
	Events.taskConsequenceStart.emit(self)
	taskActions.all(func(a): return a.perform())
	Events.taskConsequenceEnd.emit(self)

func isSetup() -> bool:
	return taskActions.all(func(a): return a.isSetup())

#This function gets the next delegate that validates a chosen parameter
func ask() -> Callable:
	print('ask called')
	if isSetup():
		return Callable()
	return taskActions.filter(func(a): return not a.isSetup())[0].ask()

func complete():
	if taskActions.all(func(a): return a.try()):
		taskActions.all(func(a): return a.perform())

func reset():
	for action in taskActions:
		action.resetSetup()