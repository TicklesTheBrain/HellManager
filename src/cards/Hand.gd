extends CardContainer
class_name Hand

@export var useCardAllowed: bool = true
@export var selectedCard: Card

func useCard(card: Card):

    if not useCardAllowed:
        return
    
    if selectedCard != null:
        selectedCard.reset()
        selectedCard = null

    selectedCard = card

    while not card.isSetup():
        InputManager.activeChoice = card.ask()
        await Events.choiceMade
        if selectedCard != card:
            return
    
    card.execute()
    selectedCard = null
    disposeCard(card)    
