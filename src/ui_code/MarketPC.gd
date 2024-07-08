extends AreaPC
class_name MarketPC

func _ready():
	super()
	assert(logicalContainer is CardMarket)
	multipleRows = true


func getCardsInRows():
	var spacesDup = []
	for row in logicalContainer.spaces:
		spacesDup.push_back(row.duplicate())
	
	for row in spacesDup:
		for i in range(row.size()):
			var element = row[i]
			if element == null:
				continue
			var matching = cardUIs.filter(func(u): return u.card == element)
			if matching.size() > 0:
				row[i] = matching[0]
			else:
				row[i] = null
	return spacesDup