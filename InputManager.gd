extends Node

@export var phase: int = 1
var activeChoice: Callable = Callable()

func _ready():
	print('checking if empty callable is null ', Callable().is_null())
	print('checking if lambda is null ', (func(_c): return true).is_null())

	Events.cardClicked.connect(cardClicked)
	Events.jobClicked.connect(jobClicked)
	
func cardClicked(cardUI: CardUI, button: MouseButton):

	print('clicked on card ', cardUI, " with button ", button)

	if phase != 1:
		return

	if button == MOUSE_BUTTON_LEFT:
		cardUI.card.execute()

func jobClicked(jobUI: JobUI, button):

	print('clicked on job ', jobUI, " with button ", button)

	if not activeChoice.is_null():
		var result = activeChoice.call(jobUI.job)
		if result:
			activeChoice = Callable()



