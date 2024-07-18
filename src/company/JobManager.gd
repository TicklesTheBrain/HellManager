extends Node
class_name JobManager

func makeNewJob():
	var newJob = Job.new()
	var newStorage = TokenStorage.new()

	add_child(newJob)
	newJob.add_child(newStorage)
	newJob.storage = newStorage

	Events.jobAdded.emit(newJob)

func makeEveryoneWork():	
	for child in get_children():
			child.doWork()