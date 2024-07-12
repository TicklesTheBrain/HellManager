extends Node

#Logic signals
signal phaseEnded(phase)
signal phaseStarted(phase)
signal turnStarted(turnNo: int)
signal turnEnded(turnNo: int)
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
signal employeeFired(employee: Employee, job: Job)
signal employeeConsumed(employee: Employee, job: Job)
signal jobAdded(job: Job)
signal jobConsumed(job: Job)
signal flowAdded(from: Job, to: Job)
signal flowRemoved(from: Job, to: Job)
signal actionStarted(action: Action)
signal actionEnded(action: Action)

#Card stuff
signal cardAddedToMarket(card: Card)
signal cardTaken(card: Card)
signal cardUseStarted(card: Card)
signal cardUseEnded(card: Card)
signal cardAddedToContainer(card: Card, container: CardContainer)
signal cardRemovedFromContainer(card: Card, container: CardContainer)
signal containerShuffled(container: CardContainer)

#Goal Stuff
signal newTaskAdded(task: Task)
signal taskCompleted(task: Task)
signal taskConsequenceStart(task: Task)
signal taskConsequenceEnd()

## LOGIC META SIGNALS
signal gameStateChanged(dirty: bool)

## UI Signals
signal cardClicked(card: CardUI, button: MouseButton)
signal jobClicked(jobUI: JobUI, button: MouseButton)
signal jobClickReleased(jobUI: JobUI, button: MouseButton)
signal jobDragStart(jobUI: JobUI)
signal jobDragEnd(jobUI: JobUI)
signal taskClicked(task: TaskUI, button: MouseButton)
signal buttonClicked(someSortOfButtonMeaningHere)
signal employeeUIMouseOverStart(employeeUI: EmployeeUI)
signal employeeUIMouseOverEnd(employeeUI: EmployeeUI)
signal employeeUIDetailsRequest(employeeUI: EmployeeUI)
signal employeeUIDetailsCloseRequest(employeeUI: EmployeeUI)


#DANGER ZONE
signal choiceMade(action, choice)
