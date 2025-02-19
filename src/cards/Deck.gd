extends CardContainer
class_name Deck

@export var includeDebug: bool
@export var onlyDebug: bool
@export var deck: Array[MultiCard] = []

func unrollDeck():

	for multiCard in deck:

		#Check for correct debug flags
		if onlyDebug and not multiCard.debug:
			continue
			
		if not includeDebug and multiCard.debug:
			continue

		for card in multiCard.unroll():
			addCard(card)
	
	shuffle()


func _ready():
	unrollDeck()