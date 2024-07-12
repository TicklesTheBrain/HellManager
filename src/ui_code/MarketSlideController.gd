extends Node2D
class_name MarketUIController

@export var marketAnimator: AnimationPlayer
@export var marketContainer: CardMarket

var marketOpen: bool = false
var slideInProgress: bool = false

func _unhandled_input(event):

	if event.is_action_pressed("market_open"):
		if slideInProgress:
			return
		if marketOpen:
			closeMarket()
		else:
			openMarket()

func openMarket():
	print('market open')
	marketAnimator.play("open")
	slideInProgress = true
	marketContainer.inaccessible = true
	await marketAnimator.animation_finished
	slideInProgress = false
	marketContainer.inaccessible = false
	marketOpen = true

func closeMarket():
	print(' market close')
	marketAnimator.play("close")
	slideInProgress = true
	marketContainer.inaccessible = true
	await marketAnimator.animation_finished
	slideInProgress = false
	marketContainer.inaccessible = false
	marketOpen = false

