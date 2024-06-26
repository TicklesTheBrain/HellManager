extends Resource
class_name GameContext

var currentPhase: int
var currentTurn: int
var actingCard: Card
var actingJob: Job
var actingEmployee: Employee
var actingGoal: int
var step: int
var actionStack: Array[Action] = []

func printSelf():
    print('current Phase ', currentPhase,  ' current Turn ', currentTurn, ' actingCard ', actingCard,
     ' acting Job ', actingJob, ' acting Employee ', actingEmployee, ' actingGoal ', actingGoal, ' step ', step, ' actionStack ', actionStack)