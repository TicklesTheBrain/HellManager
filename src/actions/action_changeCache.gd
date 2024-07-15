extends Action
class_name ActionChangeCache

@export var cacheFieldName: String
@export var changeAmount: int

func performSpecific():
    var ctxt = Globals.getCtxt()
    ctxt.playerData[cacheFieldName] += changeAmount