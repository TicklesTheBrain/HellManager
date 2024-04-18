extends Node
class_name JobManager

func _unhandled_input(event):
	if event.is_action_pressed("work"):
		for child in get_children():
			child.doWork()

func makeNewJob():
	var newJob = Job.new()
	var newStorage = TokenStorage.new()

	add_child(newJob)
	newJob.add_child(newStorage)
	newJob.storage = newStorage

	Events.jobAdded.emit(newJob)