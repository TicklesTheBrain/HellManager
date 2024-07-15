extends Node

var schedule: Array[ScheduleItem] = []
var inProgress: Array[ScheduleItem] = []
var schedulerActive: bool:
    set(v):
        if schedulerActive and not v:
            finished.emit()
        if not schedulerActive and v:
            started.emit()
        schedulerActive = v

signal started
signal finished

func processScheduler():
    if schedule.size() == 0:
        schedulerActive = false
        return
    
    if inProgress.size() == 0:
        #print('processing on empty stack, schedule subject ', schedule[0].subject , ' ctxt:')
        #schedule[0].ctxt.printSelf()
        processItem(schedule.pop_front())
        return
    
    if schedule[0].ctxt.step == inProgress[0].ctxt.step:
        
        if schedule[0].subject == null or not inProgress.map(func(si): return si.subject).has(schedule[0].subject):
            #print('schedule subject ', schedule[0].subject, ' in progress subjects ', inProgress.map(func(si): return si.subject))
            processItem(schedule.pop_front())
            return
        #else:
        #    print('schedule conflict, waiting to finish')

func processItem(item: ScheduleItem):
    schedulerActive = true
    inProgress.push_back(item)
    await item.change.call()
    inProgress.erase(item)

func addToSchedule(change: Callable, animationSubject = null, ctxt: GameContext = null):

    if ctxt == null:
        ctxt = Globals.getCtxt()
    
    var newItem = ScheduleItem.new()
    newItem.change = change
    newItem.ctxt = ctxt
    newItem.subject = animationSubject
    schedule.push_back(newItem)

func _process(_delta):
   processScheduler()

class ScheduleItem:
    var change: Callable
    var ctxt: GameContext
    var subject
