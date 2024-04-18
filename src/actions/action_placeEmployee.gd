extends Action
class_name ActionPlaceEmployee

@export var employee: Employee

var job: Job

func try() -> bool:
    if employee == null or job == null or job.employee != null:
        return false
    return true

func performSpecific():
    job.employee = employee
