extends Node2D
class_name MouseOverLord

@export var hideDelay: float

var employeeToShow: Employee
var jobToShow: Job

var hidePending: Employee
var hideOverruled: bool 

func _ready():
	Events.employeeUIDetailsRequest.connect(showEmployee)
	Events.employeeUIDetailsCloseRequest.connect(hideEmployee)

func destroyCurrentEmployeeShow():
	if get_children().size() > 0:
		UIScheduler.removeAllSubjects(get_children()[0])
		get_children()[0].queue_free()


func showEmployee(empUI: EmployeeUI):
	#print('show called')

	if hidePending == empUI.employee:
		hideOverruled = true
		hidePending = null
	
	if empUI.employee == employeeToShow:
		return

	var emp = empUI.employee
	destroyCurrentEmployeeShow()
	var newShow = EmployeeUILord.makeNewEmployeeUI(emp, true)
	employeeToShow = emp
	add_child(newShow)

func hideEmployee(empUI: EmployeeUI):

	var emp = empUI.employee
	if emp != employeeToShow:
		return

	hidePending = empUI.employee
	await get_tree().create_timer(hideDelay).timeout

	if hideOverruled or employeeToShow != hidePending:
		#print('hide overruled')
		hideOverruled = false
		return

	hidePending = null
	destroyCurrentEmployeeShow()
	employeeToShow = null
