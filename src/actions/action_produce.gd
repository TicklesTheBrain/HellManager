extends Action
class_name ActionProduce

@export var producedTokens: Array[Token] = []
		
func performSpecific() -> bool:
	var storage = Globals.getCtxt().actingJob.storage
	print('storage ', storage)
	storage.addTokens(producedTokens)
	return true

func try() -> bool:
	var storage = Globals.getCtxt().actingJob.storage
	return not storage.checkFull()
