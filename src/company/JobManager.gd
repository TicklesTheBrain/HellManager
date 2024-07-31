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
	for child in get_children():
			child.doWork()

func getEmployeeJobAtCompany(employee: Employee):
	var matching = get_children().filter(func(j): return j.employee == employee)
	if matching.size() == 0:
		return null
	return matching[0]
