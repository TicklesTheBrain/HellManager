extends Node
class_name PositionController

@export var moveTime: float = 0.5
@export var logicalContainer: CardContainer

@export var resetRotation: bool = true
@export var resetRotationTo: float = 0
@export var reverseZ: bool = false

var cardUIs: Array[CardUI] = []
var setupDone: bool = false

func _ready():

	if logicalContainer and not setupDone:
		setupNewLogicalContainer()
	#InputLord.cardDragReleased.connect(_onCardDragReleased)

func addCard(card: Card):
	
	var cardUI = CardUILord.getCardUI(card)
	if cardUI == null:
		cardUI = CardUILord.makeNewCardUI(card)
	addCardUI(cardUI)
	
func removeCard(card: Card):	
	
	if CardUILord.getCardUI(card) == null:
		return
	
	var cardUI = CardUILord.getCardUI(card)
	removeCardUI(cardUI) #TODO: this is kinda ugly
	
func addCardUI(newCard: CardUI):
	
	#Set self to parent
	if newCard.get_parent() != null:
		newCard.get_parent().remove_child(newCard)
	add_child(newCard)

	#Add UI to list and make them sort themselves
	cardUIs.push_back(newCard)
	updateCardZIndex()
	scuttleCards()

func removeCardUI(cardToRemove: CardUI):
	if !cardUIs.has(cardToRemove):
		return
	
	cardUIs.erase(cardToRemove)
	scuttleCards()

func setupNewLogicalContainer(newContainer = null):

	if newContainer:
		logicalContainer = newContainer
	
	#for cases when controller is initiated later than the logical container
	for card in logicalContainer.getAll():
		addCard(card)
		
	Events.cardAddedToContainer.connect(func(c, co): if co == logicalContainer: addCard(c))
	Events.cardRemovedFromContainer.connect(func(c, co): if co == logicalContainer: removeCard(c))
	Events.containerShuffled.connect(func(co): if co == logicalContainer: showShuffle())
	setupContainerSpecific()

	setupDone = true	

func scuttleCards():
	resetCardRotation()
	#stopPreviousTween()
	scuttleCardsSpecific()

func scuttleCardsSpecific():
	print("generic scuttle cardUIs for position controller not overrriden")
	pass

func setupContainerSpecific():
	print("setup container specific not overriden, might be alright")

func resetCardRotation():
	if resetRotation:
		for card in cardUIs:
			card.rotation_degrees = resetRotationTo

func showShuffle():
	updateCardZIndex()
	showShuffleSpecific()

func showShuffleSpecific():
	pass # Override by inheriting if needed

func updateCardZIndex():
	pass

	#let's worry about this later

	# for cardDisplay in cardUIs:
	# 	var cardPosition = logicalContainer.getCardPosition(cardDisplay.cardData)
	# 	if reverseZ:
	# 		cardDisplay.setRegularZIndex(-cardPosition)
	# 	else:
	# 		cardDisplay.setRegularZIndex(cardPosition)





