extends Action
class_name ActionConsume

@export var requiredTokens: Array[Token] = []
@export var limit: int = 999

func try() -> bool:	
	return jobAttachedTo.getTokens(requiredTokens, [], limit).size() == min(requiredTokens.size(), limit)
		
func performSpecific():
	var tokens = jobAttachedTo.getTokens(requiredTokens, [], limit)
	if limit == 1:
		print('tokens acquired ', tokens)
	jobAttachedTo.acquireTokens(tokens)
	jobAttachedTo.consumeTokens(tokens.map(func(tp): return tp.token))
	return true
