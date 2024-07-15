extends ProtoCardUI
class_name ActionCardUI

@export var nameOfCard: Label
@export var cardText: Label
@export var employeePos: Node2D
@export var cardPic: TextureRect


func updateCardUI():
	if card == null:
		return
	
	nameOfCard.text = card.cardName
	cardText.text = card.cardText

	if not card.employee == null:
		var empUI = EmployeeUILord.makeNewEmployeeUI(card.employee)
		employeePos.add_child(empUI)
	else:
		cardPic.texture = card.cardIcon

func _on_card_frame_gui_input(event):
	if event is InputEventMouseButton and event.is_released():
		Events.actionCardClicked.emit(self, event.button_index)
		
