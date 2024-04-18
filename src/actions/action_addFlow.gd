extends Action
class_name ActionAddFlow

var from: Job
var to: Job

func setup(jobFrom: Job, jobTo: Job):
	from = jobFrom
	to = jobTo

func try() -> bool:
	if from == null or to == null:
		return false
	return not to.inflow.has(from)

func performSpecific() -> bool:
	to.inflow.push_back(from)
	Events.flowAdded.emit(from, to)
	return true