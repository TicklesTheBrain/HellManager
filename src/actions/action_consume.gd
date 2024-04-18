extends Action
class_name ActionConsume

@export var requiredTokens: Array[Token] = []

func try() -> bool:
	var job = Globals.getCtxt().actingJob
	return job.fulfillRequest(requiredTokens).size() == 0
		
func performSpecific():
	var job = Globals.getCtxt().actingJob
	return job.fulfillRequest(requiredTokens, false).size() == 0
