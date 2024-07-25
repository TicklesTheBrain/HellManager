extends Dynamic
class_name DynamicAccumulatedField

@export var fieldName: String

func getAmount(askingAction: Action) -> int:
    if askingAction[fieldName] == null:
        return 0
    if askingAction[fieldName] is int:
        return askingAction[fieldName]
    if askingAction[fieldName] is Array:
        return askingAction[fieldName].size()
    return 0