extends PositionController
class_name AreaPC

@export var area: CollisionShape2D
@export var mindCenterDistance: float
@export var maxGap: float
@export var multipleRows: bool = false
@export var rowGap: float = 25

func scuttleCardsSpecific():

	if cardUIs.size() < 1:
		return
	var numberOfRows

	var areaHeight = area.shape.get_rect().size.y
	var areaWidth = area.shape.get_rect().size.x
	var cardHeight = cardUIs[0].size.y #TODO: this is fucking ugly
	var cardUIsInRows = [cardUIs]
	
	if multipleRows:
		var spaceWithoutFirstRow = areaHeight - cardHeight
		numberOfRows = floor(spaceWithoutFirstRow/(cardHeight+rowGap))+1
		var cardUIsPerRow = ceil(cardUIs.size()/numberOfRows)
		cardUIsInRows = []
		var c = 0
		for i in range(numberOfRows):
			var newRow = []
			for ci in range(cardUIsPerRow):
				if c > cardUIs.size()-1:
					break
				newRow.push_back(cardUIs[c])
				c+=1
			cardUIsInRows.push_back(newRow)

	var centerPos = area.global_position
	var totalHeight = (cardUIsInRows.size()-1)*(cardHeight+rowGap)+cardHeight
	var firstRowCenter = centerPos-Vector2(0,totalHeight/2)
	var r = 0
	for row in cardUIsInRows:
		var rowCenter = firstRowCenter+r*Vector2(0,cardHeight+rowGap)
		scuttleOneRow(row, rowCenter, areaWidth)
		r+=1	

func scuttleOneRow(rowCards, centerPos: Vector2, areaWidth: float):

	if rowCards.size() == 0:
		return

	var cardWidth = rowCards[0].size.x
	var distanceBetweenCards = mindCenterDistance
	var startingPoint: Vector2

	if rowCards.size() == 1:
		distanceBetweenCards = 0
	elif (rowCards.size()-1)*maxGap+rowCards.size()*cardWidth < areaWidth:
		distanceBetweenCards = maxGap+cardWidth
	elif cardWidth+(rowCards.size()-1)*mindCenterDistance >= areaWidth:
		distanceBetweenCards = mindCenterDistance
		startingPoint = centerPos - Vector2(areaWidth/2,0) + Vector2(cardWidth/2,0)
	else:
		distanceBetweenCards = (areaWidth - cardWidth) / (rowCards.size()-1)
	
	var totalCardWidth = cardWidth + distanceBetweenCards*(rowCards.size()-1)
	if not startingPoint:
		startingPoint = centerPos - Vector2(totalCardWidth/2, 0) + Vector2(cardWidth/2,0)

	var i = 0
	
	for card: CardUI in rowCards:
		var cardPosition = startingPoint + Vector2(i*distanceBetweenCards,0)
		i +=1
		var newTween = get_tree().create_tween()
		newTween.tween_property(card,"position", cardPosition, moveTime)
	


