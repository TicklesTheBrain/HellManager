extends Action
class_name ActionChangeTaskDelay
#Changes frequency timer on tasks

@export var delayChange: int = 1
@export var delaySet: bool = false
@export var choiceBased: bool = false
@export var condition: Condition
@export var basedOnChoice: bool = true

var tasks: Array[ProtoCard] #TODO: need to fix casting for this below, should be Array[TaskCard]

func isSetup() -> bool:
	if not basedOnChoice: return true
	return tasks != null

func try() -> bool:
	return true

func performSpecific():

	if not choiceBased:
		var allTasks = Globals.getTaskHand().getAll()
		if condition == null:
			tasks = allTasks
		else:
			tasks = allTasks.filter(func(t): return condition.checkSubject(t))

	tasks.all(func (t):
		if not delaySet:
			t.frequencyTimer += delayChange
		else:
			t.frequencyTimer = delayChange
	)
	return true

func ask() -> Callable:
	if not isSetup():
		return recordChoice
	return Callable()

func recordChoice(smth):
	if checkChoice(smth):
		tasks = [smth]
		announceChoice(smth)
		return true
	return false

func checkChoice(smth) -> bool:
	if not (smth is TaskCard):
		return false

	if condition == null:
		return true

	return condition.checkSubject(smth)
