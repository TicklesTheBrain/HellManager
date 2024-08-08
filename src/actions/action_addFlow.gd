extends Action
class_name ActionAddFlow

var from: Job
var to: Job

func isSetup() -> bool:
	if from == null or to == null:
		return false
	return true

func ask() -> Callable:
	if not isSetup():
		if from == null:
			Events.requestMessage.emit('Choose the subservient job')
		elif to == null:
			Events.requestMessage.emit('Choose the supervising job')
		return recordChoice
	return Callable()

func try() -> bool:
	if from == null or to == null:
		return false
	return not to.inflow.has(from)

func performSpecific() -> bool:
	to.inflow.push_back(from)
	from.outflow.push_back(to)
	Events.flowAdded.emit(from, to)
	return true

func recordChoice(smth):
	if checkChoice(smth):
		if from == null:
			from = smth
			
		elif to == null:
			to = smth
		Events.clearMessage.emit()
		announceChoice(smth)
		return true
	return false

func checkChoice(smth) -> bool:

	if not (smth is Job):
		return false
	if from != null and to != null:
		return false	
	if from != null and smth.inflow.has(from):
		return false
	if from != null and to == null and smth.inflow.size() >= smth.employee.skill:
		return false
	if from != null and smth == from:
		return false
		
	return true

func resetSetup():
	from = null
	to = null
