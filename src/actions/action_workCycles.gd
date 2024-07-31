extends Action
class_name ActionWorkCycles

@export var amountOfCycles: int = 1

func try():
    return true

func performSpecific():
    for i in range(amountOfCycles):
        Globals.getJobManager().makeEveryoneWork()