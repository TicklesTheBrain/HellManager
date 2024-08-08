extends Resource
class_name MultiCard

@export var copies: int = 1
@export var card: ProtoCard
@export var debug: bool
@export var randomEmployees: Array[Employee] = []

func unroll():
    var list: Array[ProtoCard] = []
    for i in range(copies):
        var newCard = card.specificDuplicate()
        list.push_back(newCard)
        if randomEmployees.size() > 0:
            newCard.employee = randomEmployees.pick_random().duplicate()
    return list