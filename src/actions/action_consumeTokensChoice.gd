extends Action
class_name ActionConsumeTokensChoice

@export var tokensRequired: Array[Token] = []
@export var requiresEmployeesPresent: bool = false
@export var numberOfMaxJobs: int = 1
var jobs: Array[Job] = []

func isSetup() -> bool:
	return checkJobsFulfillRequirement()

func try() -> bool:
	return checkJobsFulfillRequirement()

func performSpecific():

	if requiresEmployeesPresent:

		var tempJob = Job.new()
		var tempEmployee = Employee.new()
		tempJob.employee = tempEmployee

		tempJob.inflow = jobs
		var tokenPaths = tempJob.getTokens(tokensRequired)
		var tokens = tokenPaths.map(func(tp): return [tp.path[0], tp.token]) 
		for token in tokens:
			token[0].consumeTokens([token[1]])
		
		tempJob.queue_free()

		return true

	else:
		var tokensToConsume = tokensRequired.duplicate()
		
		for job in jobs:
			var got = job.storage.getTokens(tokensToConsume)
			# print('job ', job, ' is going to consume ', got, ' tokens')
			job.consumeTokens(got)
			tokensToConsume = Globals.subtractTokenList(tokensToConsume,got)
		return true


func ask() -> Callable:
	if not isSetup():
		if jobs.size() == 0:
			Events.requestMessage.emit('Choose jobs from which to consume tokens', get_instance_id())
		else:
			Events.requestMessage.emit('Choose more jobs from which to consume tokens', get_instance_id())
		return recordChoice
	return Callable()

func recordChoice(smth):
	if checkChoice(smth):
		jobs.push_back(smth)
		announceChoice(smth)
		Events.clearMessage.emit(get_instance_id())
		return true
	return false

func checkChoice(smth) -> bool:
	if not (smth is Job):
		return false

	if jobs.has(smth):
		return false

	if requiresEmployeesPresent and smth.employee == null:
		return false

	var potentialNewJobList  = jobs.duplicate()
	potentialNewJobList.push_back(smth)

	var currentAmount = getAmountGotWithJobList(jobs)
	var newAmount = getAmountGotWithJobList(potentialNewJobList)

	if jobs.size() + 1 == numberOfMaxJobs:

		return newAmount == tokensRequired.size()

	return newAmount > currentAmount


func resetSetup():
	jobs = []
	Events.clearMessage.emit(get_instance_id())

func checkJobsFulfillRequirement():
	
	return getAmountGotWithJobList(jobs) == tokensRequired.size()


func getAmountGotWithJobList(jobList: Array[Job]):

	if requiresEmployeesPresent:

		var tempJob = Job.new()
		var tempEmployee = Employee.new()
		tempJob.employee = tempEmployee

		tempJob.inflow = jobList
		var tokens = tempJob.getTokens(tokensRequired)
		tempJob.queue_free()
		return tokens.size()
		

	else:
		var tokensToConsume = tokensRequired.duplicate()
		
		for job in jobList:
			var got = job.storage.getTokens(tokensToConsume)
			tokensToConsume = Globals.subtractTokenList(tokensToConsume, got)
		
		return tokensRequired.size() - tokensToConsume.size()



