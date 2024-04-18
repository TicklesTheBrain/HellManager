extends Node

func _ready():
    Events.cardClicked.connect(func(c, b): print("clicked", c, "button", b))
    