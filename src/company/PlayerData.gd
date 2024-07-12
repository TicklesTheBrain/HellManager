extends Node
class_name PlayerData

@export var cacheA: int = 5:
    set(v):
        cacheA = v
        cacheChange.emit("cacheA", v)
@export var cacheB: int = 0:
    set(v):
        cacheB = v
        cacheChange.emit("cacheB", v)

signal cacheChange(name: String, amount: int)
