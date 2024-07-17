extends Resource
class_name GameContext

var currentPhase: int
var currentTurn: int
var actingCard: ProtoCard
var actingJob: Job
var actingEmployee: Employee
var step: int
var actionStack: Array[Action] = []
var playerData: PlayerData

func printSelf():
    print('current Phase ', currentPhase,  ' current Turn ', currentTurn, ' actingCard ', actingCard,
     ' acting Job ', actingJob, ' acting Employee ', actingEmployee, ' step ', step, ' actionStack ', actionStack)