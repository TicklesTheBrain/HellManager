extends Node
class_name Job

@export var priority: int = 1
@export var inflow: Array[Job] = []:
	get:
		inflow.sort_custom(func(a,b): return a.priority < b.priority)
		return inflow

@export var outflow: Array[Job] = []
		
@export var employee: Employee:
	set(v):
		if employee == null:
			employee = v
			Events.employeePlaced.emit(v, self)
			employee.triggerPlaced(self) #TODO: THIS NOT GOOD
		if v == null and employee != null:
			var oldEmployee = employee
			employee = v
			Events.employeeRemoved.emit(oldEmployee, self)
@export var storage: TokenStorage

func _ready():
	Events.jobDestroyed.connect(clearDeadFlows)

func clearDeadFlows(destroyedJob: Job):
	inflow.erase(destroyedJob)
	outflow.erase(destroyedJob)

func doWork():
	Events.jobStarted.emit(self)
	if employee != null:
		employee.doWork(self)
	Events.jobEnded.emit(self)

func destroy():
	Events.jobDestroyed.emit(self)
	queue_free()

func listTokensOwn():
	return storage.contents.map(func(t): return TokenPath.new(t, [self]))

func getTokens(request: Array[Token], exclude: Array[Token] = [], limit: int = 999):

	if employee == null:
		return []

	if employee.checkJobMethodReplacement("getTokens"):
		return employee.invokeJobMethodReplacement("getTokens", [self, request, exclude, limit])

	var own: Array[TokenPath]
	own.assign(getTokensOwn(request, exclude))
	var requestModified = Globals.subtractTokenList(request, own.map(func(tp): return tp.token))
	var excludeModified = exclude.duplicate()
	excludeModified.append_array(own.map(func(tp): return tp.token))
	var networkTokens = getTokensNetwork(requestModified, excludeModified, limit)
	own.append_array(networkTokens)
	if own.size() > limit:
		own = own.slice(0, limit)
	return own

func getTokensOwn(request: Array[Token], exclude: Array[Token] = [], limit: int = 999):

	if employee == null:
		return []

	if employee.checkJobMethodReplacement("getTokensOwn"):
		return employee.invokeJobMethodReplacement("getTokensOwn", [self, request, exclude, limit])

	if storage == null:
		return [] as Array[Token]
	var ownTokens = storage.getTokens(request, exclude)
	if ownTokens.size() > limit:
		ownTokens = ownTokens.slice(0, limit)
	var ownTokensTP: Array[TokenPath]
	ownTokensTP.assign(ownTokens.map(func(t): return TokenPath.new(t, [self])))
	return ownTokensTP

func getTokensNetwork(request: Array[Token], exclude: Array[Token] = [], limit: int = 999):

	if employee == null:
		return []

	if employee.checkJobMethodReplacement("getTokensNetwork"):
		return employee.invokeJobMethodReplacement("getTokensNetwork", [self, request, exclude, limit])

	var tokensExcluded: Array[Token] = exclude.duplicate()
	var requestModified: Array[Token] = request.duplicate()
	var got: Array[TokenPath] = []
	for job in inflow:
		var tokensGot = job.getTokensOwn(requestModified, tokensExcluded)
		requestModified = Globals.subtractTokenList(requestModified, tokensGot.map(func(tp): return tp.token))
		got.append_array(tokensGot.map(func(tp): return tp.extend(self)))
		tokensExcluded.append_array(tokensGot.map(func(tp): return tp.token))
	if got.size() > limit:
		got = got.slice(0, limit)
	return got

func acquireTokens(tokenPathArray):
	for tp in tokenPathArray:
		for i in range(tp.path.size()):
			if i == tp.path.size()-1:
				break
			tp.path[i].passToken(tp.token, tp.path[i+1])

func passToken(token: Token, passTo: Job):
	storage.removeToken(token)
	Events.tokenMoved.emit(token, self, passTo)

func consumeTokens(tokensToConsume):
	for token in tokensToConsume:
		storage.removeToken(token)
		Events.tokenConsumed.emit(token)

func storeTokens(tokens):
	storage.addTokens(tokens)
	for token in tokens:
		Events.tokenStored.emit(token, self)

class TokenPath:
	var token: Token
	var path: Array[Job]

	func _init(t: Token, p: Array[Job]):
		token = t
		path = p
	
	func extend(job: Job):
		var extended = TokenPath.new(token, path)
		extended.path.push_back(job)
		return extended
