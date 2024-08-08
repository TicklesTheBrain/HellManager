extends Node
class_name InputManager

@export var actionHand: Hand
@export var taskHand: Hand
@export var mouseOverAllowed: bool = true
@export var marketContainer: CardMarket
@export var inputLock: bool = false

var draggedCanvas: CompanyUICanvas
var draggedJob: JobUI = null
var activeChoice: Callable = Callable()
var marketMouse: bool = false
	
func _ready():
	Events.actionCardClicked.connect(cardClicked)
	Events.jobClicked.connect(jobClicked)
	Events.jobClickReleased.connect(jobClickReleased)
	Events.employeeUIMouseOverStart.connect(employeeMouseOverStart)
	Events.employeeUIMouseOverEnd.connect(employeeMouseOverEnd)
	Events.taskCardClicked.connect(taskClicked)
	Events.cardUseStarted.connect(func(_c): inputLock = true)
	Events.companyCanvasDragStart.connect(companyCanvasDragStart)
	Events.companyCanvasDragReleased.connect(companyCanvasDragEnd)
	Events.marketOpenRequest.connect(marketOpen)
	Events.marketCloseRequest.connect(marketClose)
	Events.marketMouseEnter.connect(recordMarketMouseEnter)
	Events.marketMouseLeave.connect(recordMarketMouseLeave)
	#TODO: this input locking thing is fucked, need to do it a different way
	Events.phaseStarted.connect(func(p):
		if p == Globals.phases.WORK:
			inputLock = true
		)
	UIScheduler.finished.connect(func():inputLock = false)

func recordMarketMouseEnter():
	marketMouse = true

func recordMarketMouseLeave():
	marketMouse = false

func marketOpen(controller: MarketUIController):
	cancelCanvasDrag()
	controller.openMarket()

func marketClose(controller: MarketUIController):
	cancelCanvasDrag()
	cancelJobDrag()
	controller.closeMarket()

func companyCanvasDragStart(canvas: CompanyUICanvas):
	if draggedCanvas != null or not activeChoice.is_null():
		return
	
	if Globals.slideInProgress or Globals.marketOpen:
		return
	
	draggedCanvas = canvas
	canvas.drag = true

func companyCanvasDragEnd(canvas: CompanyUICanvas):
	if not canvas.drag:
		return

	cancelCanvasDrag()

func taskClicked(taskUI: TaskCardUI, button):
	print('task clicked')
	cancelCanvasDrag()
	if not activeChoice.is_null():
		stopChoice()
		return
	if not inputLock and button == MOUSE_BUTTON_LEFT:
		taskHand.useCard(taskUI.card, receiveActiveChoice)

func employeeMouseOverStart(empUI: EmployeeUI):
	if mouseOverAllowed and empUI.requestMouseOver and draggedJob == null:
		if marketMouse:
			if Globals.getJobManager().getEmployeeJobAtCompany(empUI.employee) != null:
				return
		Events.employeeUIDetailsRequest.emit(empUI)

func employeeMouseOverEnd(empUI: EmployeeUI):
	Events.employeeUIDetailsCloseRequest.emit(empUI)
	
func cardClicked(cardUI: ActionCardUI, button: MouseButton):
	cancelCanvasDrag()
	#print('card clicked on input manger, input lock is ', inputLock, ' phase is ', phase)

	if not activeChoice.is_null():
		stopChoice()

	if inputLock:
		return

	#var ctxt = Globals.get_ctxt()
	if button == MOUSE_BUTTON_LEFT and marketContainer.getCardPosition(cardUI.card) != Vector2(-1,-1):

		if marketContainer.inaccessible:
			return

		var cost = marketContainer.getColumnCost(marketContainer.getCardColumn(cardUI.card))
		# print('cost ', cost)
		if cost > Globals.actionCounter:
			return

		marketContainer.removeCard(cardUI.card)
		actionHand.addCard(cardUI.card)
		Events.cardTaken.emit(cardUI.card, cost)
		return

	#print('clicked on card ', cardUI, " with button ", button)

	if button == MOUSE_BUTTON_LEFT:
		actionHand.useCard(cardUI.card, receiveActiveChoice)

func jobClicked(jobUI: JobUI, _button):

	#print('clicked on job ', jobUI, " with button ", button)
	cancelCanvasDrag()

	if Globals.marketOpen or Globals.slideInProgress:
		return

	if not activeChoice.is_null() and not inputLock:
		#print('gonna try validate choice')
		var result = activeChoice.call(jobUI.job)
		if result:
			#print('choice accepted')
			stopChoice()
		return

	if draggedJob == null:
		draggedJob = jobUI
		#print('about to job drag start')
		Events.jobDragStart.emit(jobUI)
		return
	
func jobClickReleased(jobUI: JobUI, _button):
	#print('released on job ', jobUI, " with button ", button)
	if draggedJob == jobUI:
		cancelJobDrag()

func cancelJobDrag():
	if draggedJob != null:
		#print('about to job drag end')
		Events.jobDragEnd.emit(draggedJob)
		draggedJob = null
		return

func receiveActiveChoice(callable: Callable):
	activeChoice = callable
	Events.showChoices.emit(callable.get_object().checkChoice)

func stopChoice():
	print('stop choice')
	activeChoice = Callable()
	Events.stopShowChoices.emit()	

func cancelCanvasDrag():
	if draggedCanvas == null:
		return

	draggedCanvas.drag = false
	draggedCanvas = null
