extends Control
class_name ProtoCardUI

@export var card: ProtoCard:
	set(v):
		card = v
		updateCardUI()

func updateCardUI():
	pass