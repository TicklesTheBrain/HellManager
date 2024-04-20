extends Action
class_name ActionPlaceEmployee

@export var employee: Employee
var job: Job

func isSetup() -> bool:
    if employee == null or job == null:
        return false
    return true

func try() -> bool:
    if employee == null or job == null or job.employee != null:
        return false
    return true

func performSpecific():
    job.employee = employee
    return true

func ask() -> Callable:
    if not isSetup():
        return recordChoice
    return Callable()

func recordChoice(smth):
    if smth is Job and smth.employee == null:
        job = smth
        announceChoice(smth)
        return true
    return false
