extends PanelContainer
class_name CardUI

@export var nameOfCard: Label
@export var cardText: Label
@export var card: Card:
    set(v):
        card = v
        updateCardUI()
@export var cardStructure: Container

func updateCardUI():
    if card == null:
        return
    
    nameOfCard.text = card.cardName
    if card.employee == null:
        cardText.text = card.cardText
    else:
        var empUI = EmployeeUILord.getEmployeeUI(card.employee)
        if empUI == null:
            empUI = EmployeeUILord.makeNewEmployeeUI(card.employee)
        cardStructure.add_child(empUI)
        