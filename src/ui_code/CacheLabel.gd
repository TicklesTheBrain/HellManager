extends Label
class_name CacheLabel

@export var playerData: PlayerData
@export var propName: String

func _ready():
    text = str(playerData[propName])
    playerData.cacheChange.connect(scheduleUpdateLabel)

func scheduleUpdateLabel(uName: String, value: int):
    UIScheduler.addToSchedule(updateLabel.bind(uName, value))

func updateLabel(uName: String, value: int):
    if uName != propName:
        return
    text = str(value)
