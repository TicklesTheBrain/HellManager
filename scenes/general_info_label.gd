extends Label
class_name GeneralInfoLabel

func _ready():
    Events.requestMessage.connect(scheduleMessage)
    Events.clearMessage.connect(scheduleClear)

func scheduleMessage(someText: String):
    UIScheduler.addToSchedule(showText.bind(someText))

func scheduleClear():
    UIScheduler.addToSchedule(clearText)

func showText(someText: String):
    text = someText

func clearText():
    text = ' ... '