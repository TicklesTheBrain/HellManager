extends Node

#Logic signals
signal phaseEnded(phase)
signal phaseStarted(phase)
signal turnStarted(turnNo: int)
signal turnEnded(turnNo: int)
signal jobStarted(job: Job)
signal jobEnded(job: Job)
signal employeeActivationStart(employee: Employee)
signal employeeActivationEnd(employee: Employee)
signal tokenConsumed(token: Token, storage: TokenStorage)
signal tokenProduced(token: Token, storage: TokenStorage)
signal employeePlaced(employee: Employee, job: Job)
signal employeeFired(employee: Employee, job: Job)
signal employeeConsumed(employee: Employee, job: Job)
signal jobAdded(job: Job)
signal jobConsumed(job: Job)
signal cardAddedToMarket(card: Card)
signal cardTaken(card: Card)
signal cardUseStarted(card: Card)
signal cardUseEnded(card: Card)
signal flowAdded(from: Job, to: Job)
signal flowRemoved(from: Job, to: Job)
signal actionStarted(action: Action)
signal actionEnded(action: Action)

signal newGoalAdded()
signal goalCompleted()
signal goalActivationStart()
signal goalActivationEnd()


## LOGIC META SIGNALS
signal gameStateChanged(dirty: bool)

## UI Signals
