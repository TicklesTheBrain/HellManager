extends Dynamic
class_name DynamicBasedOnPrestige

@export var forEveryMultipleOf: float = 1

func getAmount(askingAction: Action) -> int:
	return floor(askingAction.jobAttachedTo.employee.prestige / forEveryMultipleOf)
