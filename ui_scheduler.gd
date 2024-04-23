extends Node

var schedule: Array[ScheduleItem] = []
var inProgress: Array[ScheduleItem] = []
var schedulerActive: bool

func processScheduler():
    if schedule.size() == 0:
        return
    
    if inProgress.size() == 0:
        processItem(schedule.pop_front())
        return
    
    if schedule[0].ctxt.step == inProgress[0].ctxt.step:
        processItem(schedule.pop_front())
        return

func processItem(item: ScheduleItem):
    inProgress.push_back(item)
    await item.change.call()
    inProgress.erase(item)

func addToSchedule(change: Callable, ctxt: GameContext):
    var newItem = ScheduleItem.new()
    newItem.change = change
    newItem.ctxt = ctxt
    schedule.push_back(newItem)

func _process(_delta):
   processScheduler()

class ScheduleItem:
    var change: Callable
    var ctxt: GameContext
