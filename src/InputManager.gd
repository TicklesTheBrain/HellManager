extends Node
class_name InputManager

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
	#TODO: this input locking thing is fucked, need to do it a different way
	Events.phaseStarted.connect(func(p):
		if p == Globals.phases.WORK:
			inputLock = true
		)
	UIScheduler.finished.connect(func():inputLock = false)

func taskClicked(taskUI: TaskCardUI, button):
	if not inputLock and button == MOUSE_BUTTON_LEFT:
		# print('task clicked')
		taskHand.useCard(taskUI.card, receiveActiveChoice)

func employeeMouseOverStart(empUI: EmployeeUI):
	if mouseOverAllowed and empUI.requestMouseOver:
		Events.employeeUIDetailsRequest.emit(empUI)

func employeeMouseOverEnd(empUI: EmployeeUI):
	Events.employeeUIDetailsCloseRequest.emit(empUI)
	
func cardClicked(cardUI: ActionCardUI, button: MouseButton):

	#print('card clicked on input manger, input lock is ', inputLock, ' phase is ', phase)

	if inputLock:
		return

	#var ctxt = Globals.get_ctxt()


	if button == MOUSE_BUTTON_LEFT and marketContainer.getCardPosition(cardUI.card) != Vector2(-1,-1):

		if marketContainer.inaccessible:
			return

		marketContainer.removeCard(cardUI.card)
		actionHand.addCard(cardUI.card)
		Events.cardTaken.emit(cardUI.card)
		return

	#print('clicked on card ', cardUI, " with button ", button)

	if button == MOUSE_BUTTON_LEFT:
		actionHand.useCard(cardUI.card, receiveActiveChoice)

func jobClicked(jobUI: JobUI, _button):

	#print('clicked on job ', jobUI, " with button ", button)

	if Globals.marketOpen or Globals.slideInProgress:
		return

	if not activeChoice.is_null() and not inputLock:
		#print('gonna try validate choice')
		var result = activeChoice.call(jobUI.job)
		if result:
			#print('choice accepted')
			Events.stopShowChoices.emit()
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
	Events.showChoices.emit(callable.get_object().checkChoice)



