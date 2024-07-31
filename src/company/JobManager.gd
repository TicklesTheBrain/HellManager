extends Node
class_name JobManager

func makeNewJob():
	var newJob = Job.new()
	var newStorage = TokenStorage.new()

	add_child(newJob)
	newJob.add_child(newStorage)
	newJob.storage = newStorage

	Events.jobAdded.emit(newJob)

	return newJob

func makeEveryoneWork():
	var allJobs = get_children()
	allJobs.sort_custom(func(a,b):
			var aPrio = 0
			var bPrio = 0
			if a.employee != null: aPrio = a.employee.prestige
			if b.employee != null: bPrio = b.employee.prestige
			return aPrio < bPrio
	)
	
	for job in allJobs:
			job.doWork()

func getEmployeeJobAtCompany(employee: Employee):
	var matching = get_children().filter(func(j): return j.employee == employee)
	if matching.size() == 0:
		return null
	return matching[0]
