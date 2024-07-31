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
		#schedule.sort_custom(func(a,b): return a.ctxt.step < b.ctxt.step)
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
	# print('about to call this object ', item.change.get_object(), ' arguments ', item.change.get_method(), item.change.get_bound_arguments())
	await item.change.call()
	inProgress.erase(item)

func addToSchedule(change: Callable, animationSubject = null, ctxt: GameContext = null):

	if ctxt == null:
		ctxt = Globals.getCtxt()

	#print('added to schedule step' , ctxt.step)
	
	var newItem = ScheduleItem.new()
	newItem.change = change
	newItem.ctxt = ctxt
	newItem.subject = animationSubject
	# print ('added to schedule ', newItem.change.get_object())
	schedule.push_back(newItem)


#TODO: mThis probably need to be implemented widely
func removeAllSubjects(subject):

	var matching = schedule.filter(func(si): return si.subject == subject)
	for toRemove in matching:
		schedule.erase(toRemove)

func _process(_delta):
	processScheduler()

class ScheduleItem:
	var change: Callable
	var ctxt: GameContext
	var subject
