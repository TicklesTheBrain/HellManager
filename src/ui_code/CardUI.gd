extends Control
class_name CardUI

@export var nameOfCard: Label
@export var cardText: Label
@export var card: Card:
	set(v):
		card = v
		updateCardUI()
@export var employeePos: Node2D
@export var cardPic: TextureRect


func updateCardUI():
	if card == null:
		return
	
	nameOfCard.text = card.cardName
	cardText.text = card.cardText

	if not card.employee == null:
		var empUI = EmployeeUILord.getEmployeeUI(card.employee)
		if empUI == null:
			empUI = EmployeeUILord.makeNewEmployeeUI(card.employee)
		if empUI.get_parent() != null:
			empUI.get_parent().remove_child(empUI)
		employeePos.add_child(empUI)
	else:
		cardPic.texture = card.cardIcon

func _on_card_frame_gui_input(event):
	if event is InputEventMouseButton and event.is_released():
		Events.cardClicked.emit(self, event.button_index)
		
