extends Node
class_name InputManager

@export var phase: int = 1
@export var hand: Hand

var activeChoice: Callable = Callable()

func _ready():
	print('checking if empty callable is null ', Callable().is_null())
	print('checking if lambda is null ', (func(_c): return true).is_null())

	Events.cardClicked.connect(cardClicked)
	Events.jobClicked.connect(jobClicked)
	
func cardClicked(cardUI: CardUI, button: MouseButton):

	print('clicked on card ', cardUI, " with button ", button)

	if phase == 1 and button == MOUSE_BUTTON_LEFT:
		hand.useCard(cardUI.card, receiveActiveChoice)

func jobClicked(jobUI: JobUI, button):

	print('clicked on job ', jobUI, " with button ", button)

	if not activeChoice.is_null():
		print('gonna try validate choice')
		var result = activeChoice.call(jobUI.job)
		if result:
			print('choice accepted')
			activeChoice = Callable()

func receiveActiveChoice(callable: Callable):
	activeChoice = callable



