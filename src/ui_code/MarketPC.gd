extends AreaPC
class_name MarketPC

var spacedCardUIs = []

func getCardsInRows():
	return spacedCardUIs

func setupContainerSpecific():
	assert(logicalContainer is CardMarket)
	multipleRows = true
	logicalContainer.updatedPosition.connect(scheduleUpdateCardPosition)
	for r in range(logicalContainer.rows):
		var newRow = []
		newRow.resize(logicalContainer.columns)
		spacedCardUIs.push_back(newRow)

func addCardUISpecific(card: ProtoCardUI):
	var logicalPos = logicalContainer.getCardPosition(card.card)
	spacedCardUIs[logicalPos.x][logicalPos.y] = card

func removeCardUISpecific(card: ProtoCardUI):
	for r in range(spacedCardUIs.size()):
		var row = spacedCardUIs[r]
		for c in range(row.size()):
			if spacedCardUIs[r][c] == card:
				spacedCardUIs[r][c] = null
				return

func scheduleUpdateCardPosition(card: ProtoCard, oldPosition: Vector2, newPosition: Vector2):
	UIScheduler.addToSchedule(updateCardPosition.bind(card, oldPosition, newPosition))

func updateCardPosition(card: ProtoCard, oldPosition: Vector2, newPosition: Vector2):
	spacedCardUIs[newPosition.x][newPosition.y] = CardUILord.getCardUI(card)
	spacedCardUIs[oldPosition.x][oldPosition.y] = null

