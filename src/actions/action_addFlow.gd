extends Action
class_name ActionAddFlow

var from: Job
var to: Job

func isSetup() -> bool:
	if from == null or to == null:
		return false
	return true

func ask() :
	if from == null:
		return recordFrom
	elif to == null:
		return recordTo

	return (func(_a): return true)

func try() -> bool:
	if from == null or to == null:
		return false
	return not to.inflow.has(from)

func performSpecific() -> bool:
	to.inflow.push_back(from)
	Events.flowAdded.emit(from, to)
	return true

func checkAcceptChoice(choice) -> bool:
	return choice is Job

func recordFrom(smth):
	if checkAcceptChoice(smth):
		from = smth
		return true
	return false

func recordTo(smth):
	if checkAcceptChoice(smth):
		to = smth
		return true
	return false