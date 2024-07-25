extends Action
class_name ActionChangePrestige

@export var amountOfChange: int = 1
@export var choiceBased: bool = false
var employee: Employee

func performSpecific():
	if not choiceBased:
		employee = jobAttachedTo.employee
	if employee == null: return
	employee.prestige += amountOfChange

func try():
	if jobAttachedTo.employee == null and employee == null:
		return false
	return true

func isSetup() -> bool:
	if not choiceBased:
		return true
	if employee == null:
		return false
	return true

func ask() -> Callable:
	if not isSetup():
		Events.requestMessage.emit('choose employee job')
		return recordChoice
	return Callable()

func recordChoice(smth):
	if checkChoice(smth):
		employee = smth
		Events.clearMessage.emit()
		announceChoice(smth)
		return true
	return false

func checkChoice(smth) -> bool:

	if not (smth is Employee):
		return false	
	return true
