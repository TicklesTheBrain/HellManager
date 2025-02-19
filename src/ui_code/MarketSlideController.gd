extends Node2D
class_name MarketUIController

@export var marketAnimator: AnimationPlayer
@export var marketContainer: CardMarket

func _unhandled_input(event):

	if event.is_action_pressed("market_open"):
		if Globals.slideInProgress:
			return
		if Globals.marketOpen:
			Events.marketCloseRequest.emit(self)
		else:
			Events.marketOpenRequest.emit(self)

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

func _on_panel_mouse_entered():
	Events.marketMouseEnter.emit()

func _on_panel_mouse_exited():
	Events.marketMouseLeave.emit()