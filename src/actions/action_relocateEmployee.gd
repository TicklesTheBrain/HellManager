extends Action
class_name ActionRelocateEmployee
#Removes employee from job and places it back into the hand

@export var relocationCard: ActionCard
@export var condition: Condition
@export var basedOnChoice: bool = true

var job: Job

func isSetup() -> bool:
	if not basedOnChoice: return true
	return job != null

func try() -> bool:
	if not basedOnChoice: return jobAttachedTo.employee != null
	return job != null and job.employee != null

func performSpecific():
	
	var aj
	if not basedOnChoice:
		aj = jobAttachedTo
	else:
		aj = job
	
	var emp = aj.employee
	aj.employee = null
	Events.employeeRelocated.emit(emp, aj)
	var newCard = relocationCard.duplicate()
	newCard.employee = emp
	var hand = Globals.getActionHand()
	hand.addCard(newCard)
	return true

func ask() -> Callable:
	if not isSetup():
		return recordChoice
	return Callable()

func recordChoice(smth):
	if checkChoice(smth):
		job = smth
		announceChoice(smth)
		return true
	return false

func checkChoice(smth) -> bool:
	if not (smth is Job):
		return false
	
	if smth.employee == null:
		return false

	if condition == null:
		return true

	return condition.checkSubject(smth)