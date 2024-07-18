extends Node
class_name CardContainer

@export var cap: int = -1
@export var cards: Array[ProtoCard] = []
@export var feedContainer: CardContainer # Container which is reshuffled if container is empty on drawCard function
@export var disposeContainer: CardContainer # Container to which things are disposed to on disposeCards call
@export var overrideRevealed: bool = false
@export var overrideRevealedState: bool = true
@export var addToTopWhenFeeding: bool = true

signal shuffled()
signal updated()

func removeCard(cardToRemove: ProtoCard) -> bool:
	if cards.has(cardToRemove):
		cards.erase(cardToRemove)
		Events.cardRemovedFromContainer.emit(cardToRemove, self)
		return true
	return false

func getFreeSpace() -> int:
	if cap == -1:
		return cap
	else:
		return cap - cards.size()

func addCard(cardToAdd: ProtoCard, addToTop: bool = false) -> bool:

	if not checkFull():
		if addToTop:
			cards.push_front(cardToAdd)
		else:
			cards.push_back(cardToAdd)
		
		if overrideRevealed:
			cardToAdd.revealed = overrideRevealedState

		Events.cardAddedToContainer.emit(cardToAdd, self)

		return true
	return false

func checkFull() -> bool:
	return cap >= 0 and cards.size() >= cap

func checkEmpty() -> bool:
	return cards.size() == 0

func shuffle():
	cards.shuffle()
	Events.containerShuffled.emit(self)

func getTop() -> ProtoCard:
	return cards.front()

func getLast(toLast: int = 1) -> ProtoCard:
	var ind = cards.size() - toLast
	assert(ind >= 0 and ind < cards.size())
	return cards[ind]

func getAll() -> Array[ProtoCard]:
	return cards.duplicate()

func removeAll():
	var allCards = cards.duplicate()
	for card in allCards:
		removeCard(card)

func drawCard() -> ProtoCard:
	if checkEmpty():
		if feedContainer:
			if feedContainer.checkEmpty():
				return
		else:
			return
		while (not checkFull() and not feedContainer.checkEmpty()):
			var newCard = feedContainer.drawCard()
			addCard(newCard, addToTopWhenFeeding)
		shuffle()
	var cardToDraw = getTop()
	removeCard(cardToDraw)
	return cardToDraw

func disposeAll(containerToDisposeTo: CardContainer = disposeContainer):
	while (not checkEmpty()):
		if containerToDisposeTo.checkFull():
			print('dispose container full')
			return
		var card = getTop()
		disposeCard(card, containerToDisposeTo)

func disposeCard(cardToDispose: ProtoCard, containerToDisposeTo: CardContainer = disposeContainer):
	if containerToDisposeTo.checkFull():
		return
	removeCard(cardToDispose)
	containerToDisposeTo.addCard(cardToDispose)

func getNoOfCards():
	return cards.size()

func getCardPosition(card: ProtoCard):
	return cards.find(card)
