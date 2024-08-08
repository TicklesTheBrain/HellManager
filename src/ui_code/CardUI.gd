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

func _on_area_2d_input_event(_viewport:Node, event:InputEvent, _shape_idx:int):
	if event is InputEventMouseButton and event.is_released():
		# print('action card clicked ', self)
		Events.actionCardClicked.emit(self, event.button_index)
