extends Node
class_name Job

@export var priority: int = 1
@export var inflow: Array[Job] = []:
	get:
		inflow.sort_custom(func(a,b): return a.priority < b.priority)
		return inflow
		
@export var employee: Employee:
	set(v):
		employee = v
		Events.employeePlaced.emit(v, self)
@export var storage: TokenStorage

func doWork():
	Events.jobStarted.emit(self)
	if employee != null:
		employee.doWork(self)
	Events.jobEnded.emit(self)

func fulfillRequestSolo(request: Array[Token], mock = true) -> Array[Token]:
	if storage == null:
		return request
	if mock:
		return storage.tryFulfill(request)
	else:
		return storage.fulfill(request)

func fulfillRequestNetwork(request: Array[Token], mock = true) -> Array[Token]:
	var unfilled =  request
	for job in inflow:
		unfilled = job.fulfillRequestSolo(unfilled, mock)
	return unfilled

func fulfillRequest(request: Array[Token], mock = true) -> Array[Token]:
	var unfilled = request
	unfilled = fulfillRequestSolo(unfilled, mock)
	unfilled = fulfillRequestNetwork(unfilled, mock)
	return unfilled




	

