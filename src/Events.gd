extends Node

#Logic signals
signal phaseEnded(phase)
signal phaseStarted(phase)
signal dayStarted(dayNo: int)
signal dayEnded(dayNo: int)
signal jobStarted(job: Job)
signal jobEnded(job: Job)
signal jobDestroyed(job: Job)
signal employeeActivationStart(employee: Employee)
signal employeeActivationEnd(employee: Employee)
signal tokenConsumed(token: Token)
signal tokenProduced(token: Token, job: Job)
signal tokenStored(token: Token, job: Job)
signal tokenMoved(token: Token, from: Job, to: Job)
signal employeePlaced(employee: Employee, job: Job)
signal employeeRelocated(employee: Employee, job: Job)
signal employeeDestroyed(employee: Employee, job: Job)
signal employeeRemoved(employee: Employee, job: Job)
signal jobAdded(job: Job)
signal jobConsumed(job: Job)
signal flowAdded(from: Job, to: Job)
signal flowRemoved(from: Job, to: Job)
signal actionStarted(action: Action)
signal actionEnded(action: Action)

#Card stuff
signal cardAddedToMarket(card: ProtoCard)
signal cardTaken(card: ProtoCard)
signal cardUseStarted(card: ProtoCard)
signal cardUseEnded(card: ProtoCard)
signal cardAddedToContainer(card: ProtoCard, container: CardContainer)
signal cardRemovedFromContainer(card: ProtoCard, container: CardContainer)
signal containerShuffled(container: CardContainer)

#Goal Stuff
signal newTaskAdded(task: TaskCard)
signal taskCompleted(task: TaskCard)
signal taskConsequenceStart(task: TaskCard)
signal taskConsequenceEnd()

## LOGIC META SIGNALS
signal gameStateChanged(dirty: bool)

## UI Signals
signal actionCardClicked(card: ActionCardUI, button: MouseButton)
signal marketOpenRequest(market: MarketUIController)
signal marketCloseRequest(market: MarketUIController)
signal companyCanvasDragStart(companyCanvas: CompanyUICanvas)
signal companyCanvasDragReleased(companyCanvas: CompanyUICanvas)
signal jobClicked(jobUI: JobUI, button: MouseButton)
signal jobClickReleased(jobUI: JobUI, button: MouseButton)
signal jobDragStart(jobUI: JobUI)
signal jobDragEnd(jobUI: JobUI)
signal taskCardClicked(task: TaskCardUI, button: MouseButton)
signal buttonClicked(someSortOfButtonMeaningHere)
signal employeeUIMouseOverStart(employeeUI: EmployeeUI)
signal employeeUIMouseOverEnd(employeeUI: EmployeeUI)
signal employeeUIDetailsRequest(employeeUI: EmployeeUI)
signal employeeUIDetailsCloseRequest(employeeUI: EmployeeUI)
signal requestMessage(message: String)
signal clearMessage()
signal showChoices(validator: Callable)
signal stopShowChoices

#DANGER ZONE
signal choiceMade(action, choice)
