extends Action
class_name ActionChangePrestige

@export var amountOfChange: int = 1
@export var choiceBased: bool = false
var employee: Employee

func performSpecific():
	if not choiceBased:
		employee = jobAttachedTo.employee
	if employee == null:
		return false
	employee.prestige += amountOfChange
	# print('employee prestige changed ', employee.prestige)
	return true

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
		Events.requestMessage.emit('choose employee job',  get_instance_id())
		return recordChoice
	return Callable()

func recordChoice(smth):
	if checkChoice(smth):
		employee = smth
		Events.clearMessage.emit( get_instance_id())
		announceChoice(smth)
		return true
	return false

func checkChoice(smth) -> bool:

	if not (smth is Employee):
		return false	
	return true

func resetSetup():
	employee = null
	Events.clearMessage.emit(get_instance_id())
