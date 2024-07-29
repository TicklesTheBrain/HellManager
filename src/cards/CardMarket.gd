extends CardContainer
class_name CardMarket

#This container puts cards as options on a grid.
#This then allows for interactions based on lines, rows and columns

@export var rows: int = 1
@export var columns: int = 1

var inaccessible: bool = false

signal updatedPosition(card: ProtoCard, oldPosition: Vector2, newPosition: Vector2)

enum SlideDirection {
	RIGHT,
	LEFT,
	UP,
	DOWN
}

var spaces = []

func getColumnCost(i: int):
	return i+1

func getCardColumn(card: ProtoCard):
	return getCardPosition(card).y

func _ready():
	for r in range(rows):
		var newRow = []
		newRow.resize(columns)
		spaces.push_back(newRow)
		
func removeCard(card: ProtoCard):
	for row in spaces:
		var ind = row.find(card)
		if ind != -1:
			row[ind] = null
			cards.erase(card)
			Events.cardRemovedFromContainer.emit(card, self)
			return true
	return false

func getFreeSpace():
	return getCapacity() - cards.size()

func getCapacity():
	return rows*columns

func addCard(cardToAdd: ProtoCard, _addToTop: bool = false):
	for row in spaces:
		var ind = row.find(null)
		if ind != -1:
			row[ind] = cardToAdd
			cards.push_back(cardToAdd)
			Events.cardAddedToMarket.emit(cardToAdd)
			Events.cardAddedToContainer.emit(cardToAdd, self)
			return

func checkFull():
	return getFreeSpace() == 0

func shuffle():
	#TODO: FILL THIS OUT
	pass

func getTop():
	#TODO: FILL THIS OUT
	pass

func getLast(_toLast: int = 1):
	#TODO: FILL THIS OUT
	pass

func getCardPosition(cardToFind: ProtoCard):
	for r in range(rows):
		for c in range(columns):
			if spaces[r][c] == cardToFind:
				return Vector2(r,c)
	return Vector2(-1,-1)

func slideToFill(slideDirection: SlideDirection):
	var tempSpaces = []
	if slideDirection == SlideDirection.LEFT:
		for i in range(spaces.size()):			
			var row = spaces[i]
			var newRow = row.filter(func(c): return c != null)
			newRow.resize(columns)
			tempSpaces.push_back(newRow)

	#looking through all the cards and emitting signal for ones with updated position
	for x in range(tempSpaces.size()):
		for y in range(tempSpaces[x].size()):
			if tempSpaces[x][y] == null:
				continue
			if tempSpaces[x][y] == spaces[x][y]:
				continue
			var found = false
			for i in range(spaces.size()):
				if not found:
					for c in range(spaces[i].size()):
						if spaces[i][c] == tempSpaces[x][y]:
							updatedPosition.emit(tempSpaces[x][y], Vector2(i,c), Vector2(x,y))
							found = true
							break
	# print('spaces ', spaces , ' temp spaces ', tempSpaces)

	spaces = tempSpaces
	

func fillEmpty():
	if feedContainer == null:
		return

	# print(checkFull(), feedContainer.checkEmpty())
	
	while (not checkFull() and not feedContainer.checkEmpty()):
		addCard(feedContainer.drawCard())

func refreshMarket():
	#print('refresh called')
	var cardsToRemove = getColumn(0)
	for card in cardsToRemove:
		disposeCard(card)
	
	slideToFill(SlideDirection.LEFT)
	fillEmpty()

	#print('refreshed market ', spaces)

func getColumn(columnInd: int):
	assert(columnInd < spaces[0].size())
	return spaces.map(func(r): return r[columnInd]).filter(func(c): return c != null)
