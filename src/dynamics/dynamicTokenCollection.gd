extends Resource
class_name DynamicTokenCollection

@export var tokenCollection: Array[Token]
@export var dynamicMultiplier: Dynamic

func getCollection(askingAction: Action):
    var mult = dynamicMultiplier.getAmount(askingAction)
    if mult <= 0:
        return []
    else:
        var result = []
        for i in range(mult):
            result.append_array(tokenCollection)
        return result