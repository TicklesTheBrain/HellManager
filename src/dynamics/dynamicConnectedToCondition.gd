extends Dynamic
class_name DynamicConnectedToCondition

enum WhichDirection {
	Outflow,
	Inflow,
	Both
}

@export var condition: Condition
@export var direction: WhichDirection 

func getAmount(askingAction: Action) -> int:

	var relevantJob = askingAction.jobAttachedTo
	var allConnected = []
	
	if direction == WhichDirection.Outflow:
		allConnected.append_array(relevantJob.outflow)
	if direction == WhichDirection.Inflow:
		allConnected.append_array(relevantJob.inflow)
	if direction == WhichDirection.Both:
		allConnected.append_array(relevantJob.outflow)
		allConnected.append_array(relevantJob.inflow)

	var deduplicated = []
	for job in allConnected:
		if not deduplicated.has(job):
			deduplicated.push_back(job)

	if condition == null:
		return deduplicated.size()

	var filtered = deduplicated.filter(func(j): return condition.checkSubject(j))
	return filtered.size()
