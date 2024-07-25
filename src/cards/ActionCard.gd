extends ProtoCard
class_name ActionCard

@export var employee: Employee:
	get:
		var employeeInActions = onExecute.filter(func(a): return a is ActionPlaceEmployee)
		if employeeInActions.size() > 0:
			return employeeInActions[0].employee
		return employee
	set(v):
		var employeeInActions = onExecute.filter(func(a): return a is ActionPlaceEmployee)
		if employeeInActions.size() > 0:
			employeeInActions[0].employee = v
	   
@export var cardText: String
@export var cardIcon: Texture


func preExecuteSpecific():
	Events.cardUseStarted.emit(self)

func postExecuteSpecific():
	Events.cardUseEnded.emit(self)