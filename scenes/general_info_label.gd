extends Label
class_name GeneralInfoLabel

var messageStack: Array[InfoMessage] = []

func _ready():
	Events.requestMessage.connect(addMessage)
	Events.clearMessage.connect(removeMessage)

func addMessage(newText: String, caller: int):
	removeMessage(caller)
	messageStack.push_front(InfoMessage.new(newText, caller))
	scheduleUpdateMessage()

func removeMessage(ID: int):
	var matchingMessages = messageStack.filter(func(im): return im.callerID == ID)
	if matchingMessages.size() == 0:
		return
	
	for message in matchingMessages:
		# print('message removed ', message.callerID)
		messageStack.erase(message)

	scheduleUpdateMessage()

func scheduleUpdateMessage():
	if messageStack.size() == 0:
		UIScheduler.addToSchedule(showText.bind('...'))
		return
	UIScheduler.addToSchedule(showText.bind(messageStack[0].text))

func showText(someText: String):
	text = someText

class InfoMessage:
	var text: String = ''
	var callerID: int = 0

	func _init(newText, newCallerID = 0):
		text = newText
		callerID = newCallerID
