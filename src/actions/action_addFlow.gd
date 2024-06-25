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
	if smth is Job:
		if from == null:
			from = smth
		elif to == null:
			to = smth
		announceChoice(smth)
		return true
	return false