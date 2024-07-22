extends Action
class_name ActionDelegateToOutflow

@export var actionToDelegate: Action
@export var allowDelegateOnVacant: bool = false
@export var delegateCondition: Condition

func performSpecific() -> bool:
	print('delegate action perform specific')

	var ctxt = Globals.getCtxt()
	var outflowsToDelegate = []
	for outflow in ctxt.actingJob.outflow:
		if outflow.employee == null and allowDelegateOnVacant:
			outflowsToDelegate.push_back(outflow)
			continue
		if outflow.employee == null and not allowDelegateOnVacant:
			continue
		if delegateCondition != null and delegateCondition.checkSubject(outflow.employee):
			outflowsToDelegate.push_back(outflow)
			continue
		if delegateCondition == null:
			outflowsToDelegate.push_back(outflow)

	for outflow in outflowsToDelegate:
		var newAction = actionToDelegate.duplicate()
		newAction.jobAttachedTo = outflow
		newAction.perform()
	
	print('outflows to delegate ', outflowsToDelegate)
	return outflowsToDelegate.size() > 0
