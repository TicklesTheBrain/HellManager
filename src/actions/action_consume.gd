extends Action
class_name ActionConsume

@export var requiredTokens: Array[Token] = []

func try() -> bool:
	var job = Globals.getCtxt().actingJob
	return job.getTokens(requiredTokens).size() == requiredTokens.size()
		
func performSpecific():
	var job = Globals.getCtxt().actingJob
	var tokens = job.getTokens(requiredTokens)
	job.acquireTokens(tokens)
	job.consumeTokens(tokens.map(func(tp): return tp.token))
	return true
