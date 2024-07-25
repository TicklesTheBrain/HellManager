extends Action
class_name ActionDelegateOther

@export var actionToDelegate: Action
@export var allowDelegateOnVacant: bool = false
@export var delegateCondition: Condition
@export var connectionType: InOrOut = InOrOut.Outflow

enum InOrOut {
	Inflow,
	Outflow,
	Both
}


func performSpecific() -> bool:
	print('delegate action perform specific')

	var initialList = []
	if connectionType == InOrOut.Inflow or connectionType == InOrOut.Both:
		initialList.append_array(jobAttachedTo.inflow)
	if connectionType == InOrOut.Outflow or connectionType == InOrOut.Both:
		initialList.append_array(jobAttachedTo.outflow)

	var connectedToDelegate = []
	for flow in initialList:
		if flow.employee == null and allowDelegateOnVacant:
			connectedToDelegate.push_back(flow)
			continue
		if flow.employee == null and not allowDelegateOnVacant:
			continue
		if delegateCondition != null and delegateCondition.checkSubject(flow.employee):
			connectedToDelegate.push_back(flow)
			continue
		if delegateCondition == null:
			connectedToDelegate.push_back(flow)

	for outflow in connectedToDelegate:
		var newAction = actionToDelegate.duplicate()
		newAction.jobAttachedTo = outflow
		newAction.perform()
	
	print('outflows to delegate ', connectedToDelegate)
	return connectedToDelegate.size() > 0
