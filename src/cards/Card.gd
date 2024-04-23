extends Resource
class_name Card

@export var cardName: String
@export var employee: Employee:
	get:
		var employeeInActions = onExecute.filter(func(a): return a is ActionPlaceEmployee)
		if employeeInActions.size() > 0:
			return employeeInActions[0].employee
		return employee
	   
@export var cardText: String
@export var cardIcon: Texture
@export var onExecute: Array[Action]
@export var revealed: bool = false

#this function checks if card can be executed or if some additional params are required to execute the actions, should be overrriden
func isSetup() -> bool:
	return onExecute.all(func(a): return a.isSetup())

#This function gets the next delegate that validates a chosen parameter
func ask() -> Callable:
	print('ask called')
	if isSetup():
		return Callable()
	return onExecute.filter(func(a): return not a.isSetup())[0].ask()

func execute():
	if onExecute.all(func(a): return a.try()):
		onExecute.all(func(a): return a.perform())

func reset():
	for action in onExecute:
		action.resetSetup()

func nonStupidDeepDuplicate() -> Card:
	var dupe = duplicate(true)
	dupe.onExecute.assign(onExecute.map(func(a): return a.duplicate(true) as Action) as Array[Action])
	return dupe

	
