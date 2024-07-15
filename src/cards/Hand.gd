extends CardContainer
class_name Hand

@export var useCardAllowed: bool = true
@export var selectedCard: ProtoCard

func useCard(card: ProtoCard, receiveActiveChoice: Callable):

	if getCardPosition(card) == -1:
		print("how did we even get here")
		return

	if not useCardAllowed:
		return
	
	if selectedCard != null:
		selectedCard.reset()
		selectedCard = null

	selectedCard = card

	while not card.isSetup():
		#print('inside not card is Setup')
		receiveActiveChoice.call_deferred(card.ask()) #this WHOLE CHOICE scheduling thing is a mess and should be rethought
		await Events.choiceMade
		#print('after choice made')
		if selectedCard != card:
			print('selected card abborted')
			return
	
	card.execute()
	selectedCard = null
	disposeCard(card)    
