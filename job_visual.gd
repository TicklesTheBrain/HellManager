extends Control
class_name JobUI

@export var job: Job
@export var emptyContainer: Container
@export var employeeContainer: Container
@export var storageContainer: Container
@export var tokenUIPacked: PackedScene

func _ready():
	if job != null and job.employee != null:
		addEmployee(job.employee)

	if job != null and job.storage != null:
		Events.tokenProduced.connect(func(t,s): if s == job.storage: addTokenUI(t))
		Events.tokenConsumed.connect(func(t,s): if s == job.storage: removeTokenUI(t))
		for token in job.storage.contents:
			addTokenUI(token)

	if job != null:
		Events.employeePlaced.connect(func(e,j): if j == job: addEmployee(e))
		Events.employeeFired.connect(func(_e, j): if j == job: showVacant())
		Events.employeeConsumed.connect(func(_e, j): if j == job: showVacant())
		

func addTokenUI(t: Token):
	var newToken = tokenUIPacked.instantiate()
	newToken.type = t.type
	storageContainer.add_child(newToken)
	#print('token added')

func removeTokenUI(t: Token):
	#print('remove token ui start')
	for child in storageContainer.get_children():
		#print('child type ', child.type, ' removing type ', t.type)
		if child.type == t.type:
			child.free()
			#print('token removed')
			return

func addEmployee(employee: Employee):

	emptyContainer.visible = false
	employeeContainer.add_child(EmployeeUILord.makeNewEmployeeUI(employee))

func showVacant():
	emptyContainer.visible = true