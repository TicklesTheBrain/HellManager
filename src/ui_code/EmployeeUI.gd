extends Node
class_name EmployeeUI

@export var employee: Employee:
	set(v):
		employee = v
		updateVisuals()
@export var employeeNameLabel: Label
@export var prestigeLabel: Label
@export var skillLabel: Label
@export var employeeTextLabel: Label
@export var employeePic: TextureRect
@export var requestMouseOver: bool
@export var destroyFadeTime: float
@export var exhaustedSkillModulateColor: Color

func _ready():
	if employee != null:
		updateVisuals()
		employee.prestigeChange.connect(scheduleUpdatePrestige)
		employee.skillChange.connect(scheduleUpdateSkill)
		employee.destroyed.connect(scheduleShowDestroy)
		Events.flowAdded.connect(func(_f,t):
			# print('triggered this thing', t, Globals.getJobManager().getEmployeeJobAtCompany(employee)) 
			if t == Globals.getJobManager().getEmployeeJobAtCompany(employee):
				# mprint('found match')
				scheduleUpdateSkill()
		)

func updateVisuals():
	if employeeNameLabel != null:
		employeeNameLabel.text = employee.employeeName
	if employeeTextLabel != null:
		employeeTextLabel.text = employee.staticText
	if employeePic != null:
		employeePic.texture = employee.employeePic
	if prestigeLabel != null:
		prestigeLabel.text = str(employee.prestige)
	if skillLabel != null:
		updateSkillLabel()

func _mouse_exited():
	# print('emp UI mouse leave')
	Events.employeeUIMouseOverEnd.emit(self)

func _mouse_entered():
	# print('emp UI mouse enter')
	Events.employeeUIMouseOverStart.emit(self)

func scheduleUpdatePrestige():
	# print('update prestige called')
	var newPrestige = str(employee.prestige)
	UIScheduler.addToSchedule(func(): prestigeLabel.text = newPrestige, self)

func scheduleUpdateSkill():	
	UIScheduler.addToSchedule(updateSkillLabel, self)

func showDestroy():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(Color.WHITE, 0), destroyFadeTime)
	await get_tree().create_timer(destroyFadeTime).timeout
	queue_free()

func scheduleShowDestroy():
	UIScheduler.addToSchedule(showDestroy)

func getInflows():

	var job = Globals.getJobManager().getEmployeeJobAtCompany(employee)
	if job == null:
		return 0

	return job.inflow.size()

func updateSkillLabel():
	print('update skill Label triggered')
	var skill = employee.skill
	var inflows = getInflows()
	if inflows == 0:
		skillLabel.self_modulate = Color.WHITE
		skillLabel.text = str(skill)
		print('zero inflows')
	elif inflows < skill:
		skillLabel.self_modulate = Color.WHITE
		skillLabel.text = "{s}({i})".format({"s": skill, "i":skill- inflows})
		print(' some inflows')
	else:
		skillLabel.self_modulate = exhaustedSkillModulateColor
		skillLabel.text = "{s}({i})".format({"s": skill, "i": skill - inflows})
		print('all inflows')
