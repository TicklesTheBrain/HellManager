extends Resource
class_name Token

enum Type {
    Blue,
    Red,
    Green
}

@export var type: Type

func replicateSelf():
    var replica = Token.new()
    replica.type = type
    return replica