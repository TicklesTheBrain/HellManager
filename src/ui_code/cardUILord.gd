extends Node
#Maybe consider adding this all up to a single UI factory together with employeeUI?


@export var cardUIPacked: PackedScene
@export var cardUIs: Array[CardUI] = []

func _ready():
	#potentially connect up some events here, currently no events here
	pass

func makeNewCardUI(card: Card) -> CardUI:

	var newUI = cardUIPacked.instantiate()
	newUI.card = card
	cardUIs.push_back(newUI)
	return newUI

func getCardUI(card: Card) -> CardUI:
	var matching = cardUIs.filter(func(u): return u.card == card)
	if matching.size() == 0:
		return null
	else:
		return matching[0]

func destroyCardUI(card: Card):
	var ui = makeNewCardUI(card)
	if ui != null:
		ui.queue_free()
		cardUIs.erase(ui)
