extends Action
class_name ActionCollectAndContinue

@export var requiredTokens: Array[Token] = []
@export var collectMax: bool = false
@export var additionalAction: Action
@export var recordField: String

func try() -> bool:	
	return jobAttachedTo.getTokens(requiredTokens).size() > 0 and jobAttachedTo.storage.getCapacityLeft() > 0
		
func performSpecific():

	var accessed := [] as Array[Job.TokenPath]
	var newAccess := [] as Array[Job.TokenPath]
	var capacityAvailable = jobAttachedTo.storage.getCapacityLeft()
	var first = true
	
	while (newAccess.size() > 0 or first):
		
		if not first and not collectMax:
			break

		first = false
		var limitLeft = capacityAvailable - accessed.size()
		var accessedNoTP: Array[Token]
		accessedNoTP.assign(accessed.map(func(tp): return tp.token))
		newAccess = jobAttachedTo.getTokens(requiredTokens, accessedNoTP, limitLeft)
		accessed.append_array(newAccess)

	if additionalAction != null:
		additionalAction[recordField] = accessed.map(func(tp): return tp.token)
	jobAttachedTo.acquireTokens(accessed)
	jobAttachedTo.storeTokens(accessed.map(func(tp): return tp.token))
	
	if additionalAction == null:
		return true
	var newAdditional = additionalAction.duplicate()
	newAdditional.jobAttachedTo = jobAttachedTo
	return newAdditional.perform()
