extends Action
class_name ActionDestroyEmployee

@export var selfDestroy: bool = false
@export var condition: Condition

var job: Job

func isSetup() -> bool:
	if selfDestroy: return true
	return job != null

func try() -> bool:
	if selfDestroy: return jobAttachedTo.employee != null and condition.checkSubject(jobAttachedTo.employee)
	return job != null and job.employee != null

func performSpecific():
	
	var aj
	if selfDestroy:
		if condition.checkSubject(jobAttachedTo.employee):
			aj = jobAttachedTo
		else:
			return
	else:
		aj = job
	
	var emp = aj.employee
	aj.employee = null
	Events.employeeDestroyed.emit(emp, aj)
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