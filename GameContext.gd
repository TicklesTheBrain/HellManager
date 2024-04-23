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

