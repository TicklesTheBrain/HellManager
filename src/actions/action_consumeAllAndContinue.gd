extends Action
class_name ActionConsumeAllAndContinue

@export var requiredTokens: Array[Token] = []
@export var requiredAll: bool = false
@export var additionalAction: Action
@export var recordFieldTokenList: String
@export var recordFieldTokenAmount: String

func try() -> bool:
	if requiredAll:
		requiredTokens = Token.getAllTypesCollection()
	return jobAttachedTo.getTokens(requiredTokens).size() > 0
		
func performSpecific():

	if requiredAll:
		requiredTokens = Token.getAllTypesCollection()

	var stored := [] as Array[Job.TokenPath]
	var acquired := [] as Array[Job.TokenPath]
	var first = true
	while (acquired.size() > 0 or first):
		first = false
		var storedNoTP: Array[Token]
		storedNoTP.assign(stored.map(func(tp): return tp.token))
		acquired = jobAttachedTo.getTokens(requiredTokens, storedNoTP)
		stored.append_array(acquired)

	if additionalAction != null:
		if recordFieldTokenList != '':
			additionalAction[recordFieldTokenList] = stored.map(func(tp): return tp.token)
		if recordFieldTokenAmount != '':
			additionalAction[recordFieldTokenAmount] = stored.size()

	jobAttachedTo.acquireTokens(stored)
	jobAttachedTo.consumeTokens(stored.map(func(tp): return tp.token))
	if additionalAction == null:
		return true
	var newAdditional = additionalAction.duplicate()
	newAdditional.jobAttachedTo = jobAttachedTo
	return newAdditional.perform()
