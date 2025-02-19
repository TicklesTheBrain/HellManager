extends PositionController
class_name SinkPC

@export var positionMarker: Marker2D

func scuttleCardsSpecific():
	for ui in cardUIs:
		var newTween = get_tree().create_tween()
		newTween.tween_property(ui, "position", positionMarker.position, moveTime)
		newTween.tween_callback(CardUILord.destroyCardUI.bind(ui.card))
	cardUIs = []
	await get_tree().create_timer(moveTime).timeout

