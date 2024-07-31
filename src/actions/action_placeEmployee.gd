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
        Events.requestMessage.emit('choose a vacant for this employee')
        return recordChoice
    return Callable()

func recordChoice(smth):
    if checkChoice(smth):
        job = smth
        Events.clearMessage.emit()
        announceChoice(smth)
        return true
    return false

func checkChoice(smth) -> bool:

    if not (smth is Job):
        return false
    if smth.employee != null:
        return false
    if job != null:
        return false
    if smth.inflow.size() > employee.skill:
        return false    
    
    return true
    

