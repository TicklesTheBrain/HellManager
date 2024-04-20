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
	print('record from triggered')
	if checkAcceptChoice(smth):
		from = smth
		print('record from accepted')
		announceChoice(smth)
		return true
	return false

func recordTo(smth):
	print('record to triggered')
	if checkAcceptChoice(smth):
		to = smth
		print('record to accepted')
		announceChoice(smth)
		return true
	return false
