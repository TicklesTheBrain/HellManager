extends Action
class_name ActionConsume

@export var requiredTokens: Array[Token] = []
@export var limit: int = 999

func try() -> bool:
	var job = Globals.getCtxt().actingJob
	return job.getTokens(requiredTokens).size() == requiredTokens.size()
		
func performSpecific():
	var job = Globals.getCtxt().actingJob
	var tokens = job.getTokens(requiredTokens, [], limit)
	job.acquireTokens(tokens)
	job.consumeTokens(tokens.map(func(tp): return tp.token))
	return true
