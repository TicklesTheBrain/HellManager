extends Node
class_name InputManager

@export var phase: int = 1
@export var actionHand: Hand
@export var taskHand: Hand
@export var mouseOverAllowed: bool = true
@export var marketContainer: CardMarket
@export var inputLock: bool = false

var draggedJob: JobUI = null
var activeChoice: Callable = Callable()


func _ready():
	Events.actionCardClicked.connect(cardClicked)
	Events.jobClicked.connect(jobClicked)
	Events.jobClickReleased.connect(jobClickReleased)
	Events.employeeUIMouseOverStart.connect(employeeMouseOverStart)
	Events.employeeUIMouseOverEnd.connect(employeeMouseOverEnd)
	Events.taskCardClicked.connect(taskClicked)

	Events.cardUseStarted.connect(func(_c): inputLock = true)
	Events.phaseStarted.connect(func(p):
		if p == Globals.phases.WORK:
			inputLock = true
		)
	UIScheduler.finished.connect(func():inputLock = false)

func taskClicked(taskUI: TaskCardUI, button):
	if not inputLock and button == MOUSE_BUTTON_LEFT:
		print('task clicked')
		taskHand.useCard(taskUI.card, receiveActiveChoice)

func employeeMouseOverStart(empUI: EmployeeUI):
	if mouseOverAllowed and empUI.requestMouseOver:
		Events.employeeUIDetailsRequest.emit(empUI)

func employeeMouseOverEnd(empUI: EmployeeUI):
	Events.employeeUIDetailsCloseRequest.emit(empUI)
	
func cardClicked(cardUI: ActionCardUI, button: MouseButton):

	if inputLock:
		return

	if button == MOUSE_BUTTON_LEFT and marketContainer.getCardPosition(cardUI.card) != Vector2(-1,-1):

		if marketContainer.inaccessible:
			return

		marketContainer.removeCard(cardUI.card)
		actionHand.addCard(cardUI.card)
		Events.cardTaken.emit(cardUI.card)
		return

	#print('clicked on card ', cardUI, " with button ", button)

	if phase == Globals.phases.MANAGE and button == MOUSE_BUTTON_LEFT:
		actionHand.useCard(cardUI.card, receiveActiveChoice)

func jobClicked(jobUI: JobUI, _button):

	#print('clicked on job ', jobUI, " with button ", button)

	if not activeChoice.is_null() and not inputLock:
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



