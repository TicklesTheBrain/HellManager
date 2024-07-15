extends Node
#Maybe consider adding this all up to a single UI factory together with employeeUI?

@export var actionCardUIPacked: PackedScene
@export var taskCardUIPacked: PackedScene
@export var cardUIs: Array[ProtoCardUI] = []

func _ready():
	#potentially connect up some events here, currently no events here
	pass

func makeNewCardUI(card: ProtoCard) -> ProtoCardUI:

	var newUI
	if card is ActionCard:
		print('action card created')
		newUI = actionCardUIPacked.instantiate()
	elif card is TaskCard:
		print('task card created')
		newUI = taskCardUIPacked.instantiate()
	
	print('it is ', newUI)
	newUI.card = card
	cardUIs.push_back(newUI)
	return newUI

func getCardUI(card: ProtoCard) -> ProtoCardUI:
	var matching = cardUIs.filter(func(u): return u.card == card)
	if matching.size() == 0:
		return null
	else:
		return matching[0]

func destroyCardUI(card: ProtoCard):
	var ui = getCardUI(card)
	if ui != null:

		ui.queue_free()
		cardUIs.erase(ui)
