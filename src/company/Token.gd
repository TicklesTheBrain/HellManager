extends Resource
class_name Token

enum Type {
    Blue,
    Red,
    Green,
    Purple,
    Yellow,
    Black,
    Gold,
    Diamond,
    Silver
}

@export var type: Type

func replicateSelf():
    var replica = Token.new()
    replica.type = type
    return replica

static func getAllTypesCollection():
    var collection: Array[Token] = []

    for i in range(Type.size()):
        var token = Token.new()
        token.type = i
        collection.push_back(token)
    
    return collection

static func getRandomCollection(possibleTokens: Array[Token], amount: int = 1):
    var collection: Array[Token] = []
    for i in range(amount):
        collection.push_back(possibleTokens.pick_random().replicateSelf())
    return collection