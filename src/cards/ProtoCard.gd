extends Resource
class_name ProtoCard

@export var cardName: String
@export var revealed: bool = false
@export var onExecute: Array[Action]

#this function checks if card can be executed or if some additional params are required to execute the actions, should be overrriden
func isSetup() -> bool:
	return onExecute.all(func(a): return a.isSetup())

#This function gets the next delegate that validates a chosen parameter
func ask() -> Callable:
	#print('ask called')
	if isSetup():
		return Callable()
	return onExecute.filter(func(a): return not a.isSetup())[0].ask()


func preExecuteSpecific():
	pass

func postExecuteSpecific():
	pass
	
func execute():
	preExecuteSpecific()
	if onExecute.all(func(a): return a.try()):
		onExecute.all(func(a): return a.perform())
	postExecuteSpecific()

func reset():
	for action in onExecute:
		action.resetSetup()
	
func specificDuplicate():
	var dupe = duplicate(true)
	dupe.onExecute.assign(onExecute.map(func(a): return a.duplicate(true) as Action) as Array[Action])
	return dupe