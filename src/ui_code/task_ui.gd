extends ProtoCardUI
class_name TaskCardUI

@export var nameOfTask: Label
@export var taskText: Label
@export var taskConsequenceText: Label
@export var taskIcon: TextureRect

func _ready():
	# print('task card size ', $Background.size)
	await get_tree().create_timer(0.1).timeout
	# print('task card size ', $Background.size)

func updateCardUI():
	if card == null:
		return

	nameOfTask.text = card.cardName
	taskText.text = card.taskText
	taskConsequenceText.text = card.consequenceText
	taskIcon.texture = card.taskIcon

func _on_background_gui_input(event:InputEvent):
	if event is InputEventMouseButton:
		if event.is_pressed():
			Events.taskCardClicked.emit(self, event.button_index)
