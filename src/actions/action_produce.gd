extends Action
class_name ActionProduce

@export var producedTokens: Array[Token] = []
		
func performSpecific() -> bool:
	var newTokens = jobAttachedTo.storage.addTokens(producedTokens.map(func(t): return t.replicateSelf()))
	for token in newTokens:
		Events.tokenProduced.emit(token, jobAttachedTo)
	return true

func try() -> bool:
	return not jobAttachedTo.storage.checkFull()
