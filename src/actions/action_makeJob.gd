extends Action
class_name ActionMakeJob

func performSpecific():
	Globals.getJobManager().makeNewJob()
	return true
	
