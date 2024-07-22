extends Action
class_name ActionDestroyJob

@export var condition: Condition
var job: Job

func isSetup() -> bool:
	return job != null

func try() -> bool:
	return job != null

func performSpecific():
  
	var tokens = job.listTokensOwn()
	job.consumeTokens(tokens.map(func(tp): return tp.token))
	job.destroy()
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
	# print('start check Choice')
	if job != null:
		return false

	if not (smth is Job):
		return false

	# print('going to check condition now ', condition.checkSubject(smth))
	return condition.checkSubject(smth)
