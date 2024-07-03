extends Node2D
class_name MouseOverLord

var employeeToShow: Employee
var jobToShow: Job

func _ready():
    Events.employeeUIDetailsRequest.connect(showEmployee)
    Events.employeeUIDetailsCloseRequest.connect(hideEmployee)

func destroyCurrentEmployeeShow():
    if get_children().size() > 0:
        get_children()[0].queue_free()


func showEmployee(empUI: EmployeeUI):
    var emp = empUI.employee
    destroyCurrentEmployeeShow()
    var newShow = EmployeeUILord.makeNewEmployeeUI(emp, true)
    employeeToShow = emp
    add_child(newShow)

func hideEmployee(empUI: EmployeeUI):
    var emp = empUI.employee
    if emp != employeeToShow:
        return
    destroyCurrentEmployeeShow()
    employeeToShow = null