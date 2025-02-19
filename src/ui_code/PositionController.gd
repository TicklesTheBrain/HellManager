extends Node
class_name PositionController

@export var moveTime: float = 0.5
@export var logicalContainer: CardContainer
@export var resetRotation: bool = true
@export var resetRotationTo: float = 0
@export var reverseZ: bool = false
@export var packedCardForReference: PackedScene

var cardHeight: float
var cardWidth: float

var cardUIs: Array[ProtoCardUI] = []
var setupDone: bool = false

func _ready():

	var ref = packedCardForReference.instantiate()
	cardHeight = ref.size.y
	cardWidth = ref.size.x

	#print('reference card size is ', cardHeight, ' ', cardWidth, ' for ', ref)

	if logicalContainer and not setupDone:
		setupNewLogicalContainer()
	#InputLord.cardDragReleased.connect(_onCardDragReleased)


func addCard(card: ProtoCard):
	#print('addCard called ', card)
	
	var cardUI = CardUILord.getCardUI(card)
	if cardUI == null:
		#print('new card UI requested')
		cardUI = CardUILord.makeNewCardUI(card)
	# print('scheduling addCard for ', self)
	UIScheduler.addToSchedule(addCardUISpecific.bind(cardUI))
	UIScheduler.addToSchedule(addCardUI.bind(cardUI))
	
func removeCard(card: ProtoCard):	
	
	if CardUILord.getCardUI(card) == null:
		return
	
	var cardUI = CardUILord.getCardUI(card)
	# print('scheduling removeCard for ', self)
	UIScheduler.addToSchedule(removeCardUISpecific.bind(cardUI))
	UIScheduler.addToSchedule(removeCardUI.bind(cardUI))
	
func addCardUI(newCard: ProtoCardUI):
	
	#print('add card UI called', newCard)

	#Set self to parent
	if newCard.get_parent() != null:
		newCard.get_parent().remove_child(newCard)
	add_child(newCard)
	# print('card UI added')

	#Add UI to list and make them sort themselves
	cardUIs.push_back(newCard)
	updateCardZIndex() #TODO: add back when it makes sense with UIScheduler
	# print('scheduling a scuttle for ', self)
	await scuttleCards()

func removeCardUI(cardToRemove: ProtoCardUI):
	if !cardUIs.has(cardToRemove):
		return
	
	cardUIs.erase(cardToRemove)
	# print('scheduling a scuttle for ', self)
	await scuttleCards()

func setupNewLogicalContainer(newContainer = null):

	if newContainer:
		logicalContainer = newContainer
	
	setupContainerSpecific()

	#for cases when controller is initiated later than the logical container
	for card in logicalContainer.getAll():
		addCard(card)
		
	Events.cardAddedToContainer.connect(func(c, co): if co == logicalContainer: addCard(c))
	Events.cardRemovedFromContainer.connect(func(c, co): if co == logicalContainer: removeCard(c))
	Events.containerShuffled.connect(func(co): if co == logicalContainer: showShuffle())
	#logicalContainer.updated.connect(scuttleCards)
	setupDone = true	

func scuttleCards():
	resetCardRotation()
	#stopPreviousTween()
	await scuttleCardsSpecific()

func scuttleCardsSpecific():
	print("generic scuttle cardUIs for position controller not overrriden")
	pass

func setupContainerSpecific():
	print("setup container specific not overriden, might be alright")

func addCardUISpecific(_cardUI: ProtoCardUI):
	#Just for overriding
	pass

func removeCardUISpecific(_cardUI: ProtoCardUI):
	#Just for overridingS
	pass

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
