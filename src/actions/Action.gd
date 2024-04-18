extends Resource
class_name Action

func try() -> bool:
	return true

func perform() -> bool:
	Events.actionStarted.emit(self)
	var result = performSpecific()
	Events.actionEnded.emit(self)
	return result

func performSpecific() -> bool:
	print('default perform Specific not overriden ', self)
	return true
