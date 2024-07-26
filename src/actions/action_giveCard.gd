extends Action
class_name ActionGiveCards

@export var listOfCards: Array[MultiCard]

func try():
    return not Globals.getActionHand().checkFull()

func performSpecific():
    var hand = Globals.getActionHand()
    for multi in listOfCards:
        for i in range(multi.copies):
            hand.addCard(multi.card.specificDuplicate())
    return true