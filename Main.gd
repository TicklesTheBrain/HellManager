extends Node2D

@export var deck: Deck
@export var hand: CardContainer

func _unhandled_input(event):
	if event.is_action_pressed("draw"):
		if not deck.checkEmpty() and not hand.checkFull():
			hand.addCard(deck.drawCard())
