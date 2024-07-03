extends Node
class_name InputManager

@export var phase: int = 1
@export var hand: Hand
@export var mouseOverAllowed: bool = true

var draggedJob: JobUI = null
var activeChoice: Callable = Callable()

func _ready():
	Events.cardClicked.connect(cardClicked)
	Events.jobClicked.connect(jobClicked)
	Events.jobClickReleased.connect(jobClickReleased)
	Events.employeeUIMouseOverStart.connect(employeeMouseOverStart)
	Events.employeeUIMouseOverEnd.connect(employeeMouseOverEnd)

func employeeMouseOverStart(empUI: EmployeeUI):
	if mouseOverAllowed and empUI.requestMouseOver:
		Events.employeeUIDetailsRequest.emit(empUI)

func employeeMouseOverEnd(empUI: EmployeeUI):
	Events.employeeUIDetailsCloseRequest.emit(empUI)
	
func cardClicked(cardUI: CardUI, button: MouseButton):

	#print('clicked on card ', cardUI, " with button ", button)

	if phase == 1 and button == MOUSE_BUTTON_LEFT:
		hand.useCard(cardUI.card, receiveActiveChoice)

func jobClicked(jobUI: JobUI, _button):

	#print('clicked on job ', jobUI, " with button ", button)

	if not activeChoice.is_null():
		#print('gonna try validate choice')
		var result = activeChoice.call(jobUI.job)
		if result:
			#print('choice accepted')
			activeChoice = Callable()
		return

	if draggedJob == null:
		draggedJob = jobUI
		#print('about to job drag start')
		Events.jobDragStart.emit(jobUI)
		return
	
func jobClickReleased(jobUI: JobUI, _button):
	#print('released on job ', jobUI, " with button ", button)
	if draggedJob == jobUI:
		#print('about to job drag end')
		Events.jobDragEnd.emit(jobUI)
		draggedJob = null
		return

func receiveActiveChoice(callable: Callable):
	activeChoice = callable



