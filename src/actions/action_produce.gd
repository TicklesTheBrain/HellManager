extends Action
class_name ActionProduce

@export var producedTokens: Array[Token] = []
@export var dynamic: DynamicTokenCollection
@export var randomAmount: int = 0

		
func performSpecific() -> bool:
	
	var tokensToProduce
	if dynamic == null:
		tokensToProduce = producedTokens
	else:
		tokensToProduce = dynamic.getCollection(self)

	if randomAmount > 0:
		tokensToProduce = Token.getRandomCollection(tokensToProduce, randomAmount)

	var newTokens = jobAttachedTo.storage.addTokens(tokensToProduce.map(func(t): return t.replicateSelf()))
	for token in newTokens:
		Events.tokenProduced.emit(token, jobAttachedTo)
	return true

func try() -> bool:
	return not jobAttachedTo.storage.checkFull()
