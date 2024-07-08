extends CardContainer
class_name CardMarket

#This container puts cards as options on a grid.
#This then allows for interactions based on lines, rows and columns

@export var rows: int = 1
@export var columns: int = 1

enum SlideDirection {
	Right,
	Left,
	Up,
	Down
}

var spaces = []

func _ready():
	for r in range(rows):
		var newRow = []
		for c in range(columns):
			newRow.push_back(null)
		spaces.push_back(newRow)
	fillEmpty()

func removeCard(card: Card):
	for row in spaces:
		var ind = row.find(card)
		if ind != -1:
			row[ind] = null
			cards.erase(card)
			return

func getFreeSpace():
	return getCapacity() - cards.size()

func getCapacity():
	return rows*columns

func addCard(cardToAdd: Card, _addToTop: bool = false):
	for row in spaces:
		var ind = row.find(null)
		if ind != -1:
			row[ind] = cardToAdd
			cards.push_back(cardToAdd)
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

func getCardPosition(cardToFind: Card):
	for r in range(rows):
		for c in range(columns):
			if spaces[r][c] == cardToFind:
				return Vector2(r,c)
	return Vector2(-1,-1)

func slideToFill(_slideDirection: SlideDirection):
	pass

func fillEmpty():
	if feedContainer == null:
		return

	# print(checkFull(), feedContainer.checkEmpty())
	
	while (not checkFull() and not feedContainer.checkEmpty()):
		addCard(feedContainer.drawCard())

