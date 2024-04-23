extends Control
class_name JobUI

@export var job: Job
@export var emptyContainer: Container
@export var employeePos: Node2D
@export var storageContainer: Container
@export var tokenUIPacked: PackedScene

@export var tokenFadeTime: float = 0.2


func _ready():
	if job != null and job.employee != null:
		addEmployee(job.employee)

	if job != null and job.storage != null:
		Events.tokenProduced.connect(func(t,s): if s == job.storage: scheduleUIAnim(addTokenUI.bind(t)))
		Events.tokenConsumed.connect(func(t,s): if s == job.storage: scheduleUIAnim(removeTokenUI.bind(t)))
		for token in job.storage.contents:
			addTokenUI(token)

	if job != null:
		Events.employeePlaced.connect(func(e,j): if j == job: addEmployee(e))
		Events.employeeFired.connect(func(_e, j): if j == job: showVacant())
		Events.employeeConsumed.connect(func(_e, j): if j == job: showVacant())		

func scheduleUIAnim(anim: Callable):
	UIScheduler.addToSchedule(anim, Globals.getCtxt())

func addTokenUI(t: Token):
	var newToken = tokenUIPacked.instantiate()
	newToken.type = t.type
	newToken.scale = Vector2(0,0)
	var tween = get_tree().create_tween()
	tween.tween_property(newToken,"scale", Vector2(1,1), tokenFadeTime)
	storageContainer.add_child(newToken)
	await tween.finished

func removeTokenUI(token: Token):
	var matching = storageContainer.get_children().filter(func(t): return t.type == token.type and not t.markedForConsumption)
	if matching.size() > 0:
		matching[0].markedForConsumption = true
		var tween = get_tree().create_tween()
		tween.tween_property(matching[0], "scale", Vector2(0,0), tokenFadeTime)
		await tween.finished
		matching[0].free()

func addEmployee(employee: Employee):

	emptyContainer.visible = false
	employeePos.add_child(EmployeeUILord.makeNewEmployeeUI(employee))

func showVacant():
	emptyContainer.visible = true
	
func _on_job_frame_gui_input(event):
	#print('on job frame gui input')
	if event is InputEventMouseButton and event.is_released():
		Events.jobClicked.emit(self, event.button_index)
