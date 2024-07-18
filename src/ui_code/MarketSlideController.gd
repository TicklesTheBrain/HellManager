extends Node2D
class_name MarketUIController

@export var marketAnimator: AnimationPlayer
@export var marketContainer: CardMarket

func _unhandled_input(event):

	if event.is_action_pressed("market_open"):
		if Globals.slideInProgress:
			return
		if Globals.marketOpen:
			closeMarket()
		else:
			openMarket()

func openMarket():
	# print('market open')
	marketAnimator.play("open")
	Globals.slideInProgress = true
	marketContainer.inaccessible = true
	await marketAnimator.animation_finished
	Globals.slideInProgress = false
	marketContainer.inaccessible = false
	Globals.marketOpen = true

func closeMarket():
	# print(' market close')
	marketAnimator.play("close")
	Globals.slideInProgress = true
	marketContainer.inaccessible = true
	await marketAnimator.animation_finished
	Globals.slideInProgress = false
	marketContainer.inaccessible = false
	Globals.marketOpen = false

