extends Action
class_name ActionConsumeAllAndContinue

@export var requiredTokens: Array[Token] = []
@export var additionalAction: Action
@export var recordField: String

func try() -> bool:
	var job = Globals.getCtxt().actingJob
	return job.getTokens(requiredTokens).size() > 0
		
func performSpecific():

	var stored := [] as Array[Job.TokenPath]
	var acquired := [] as Array[Job.TokenPath]
	var first = true
	while (acquired.size() > 0 or first):
		first = false
		acquired = jobAttachedTo.getTokens(requiredTokens, stored.map(func(tp): return tp.token))
		stored.append_array(acquired)
	if additionalAction != null:
		additionalAction[recordField] = stored.map(func(tp): return tp.token)
	jobAttachedTo.consumeTokens(stored.map(func(tp): return tp.token))
	if additionalAction == null:
		return true
	var newAdditional = additionalAction.duplicate()
	newAdditional.jobAttachedTo = jobAttachedTo
	return newAdditional.perform()
