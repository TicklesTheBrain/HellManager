extends Action
class_name ActionProduce

@export var producedTokens: Array[Token] = []
		
func performSpecific() -> bool:
	var ctxt = Globals.getCtxt()
	var storage = ctxt.actingJob.storage
	var newTokens = storage.addTokens(producedTokens.map(func(t): return t.replicateSelf()))
	for token in newTokens:
		Events.tokenProduced.emit(token, ctxt.actingJob)
	return true

func try() -> bool:
	var storage = Globals.getCtxt().actingJob.storage
	return not storage.checkFull()
