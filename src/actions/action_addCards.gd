extends Action
class_name ActionAddCards
#Removes employee from job and places it back into the hand

@export var actionCarsToAdd: Array[MultiCard]
@export var amount: int = 1

var job: Job

func performSpecific():
	var hand = Globals.getActionHand()
	for a in range(amount):
		for multiCard in actionCarsToAdd:
			for i in range(multiCard.copies):
					hand.addCard(multiCard.card.specificDuplicate())
	return true

func try():
	return not Globals.getActionHand().checkFull()