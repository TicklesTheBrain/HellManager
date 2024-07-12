extends Action
class_name ActionDestroyJob

@export var condition: Condition
var job: Job

func isSetup() -> bool:
    return job != null

func try() -> bool:
    return job != null

func performSpecific():
    job.destroy()
    return true

func ask() -> Callable:
    if not isSetup():
        return recordChoice
    return Callable()

func recordChoice(smth):
    if condition.checkSubject(smth):
        job = smth
        announceChoice(smth)
        return true
    return false
