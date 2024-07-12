extends Node
class_name TaskManager

@export var addTaskEveryXTurns: int = 5
var newTaskCounter: int = 0
@export var listOfPossibleTasks: Array[Task]
@export var activeTasks: Array[Task]
@export var completeTaskAllowed: bool = true
@export var selectedTask: Task

func addNewTask():
    var newTask = listOfPossibleTasks.pick_random().nonStupidDeepDuplicate()
    activeTasks.push_back(newTask)
    Events.newTaskAdded.emit(newTask)

func tickCounter():
    newTaskCounter += 1
    if newTaskCounter >= addTaskEveryXTurns:
        addNewTask()
        newTaskCounter = 0

#This whole thing was copied from hand manager, probably need to think about some unified input/choice processing refactor
func tryCompleteTask(task: Task, receiveActiveChoice):

    if activeTasks.find(task) == -1:
        print('how did we even get here')
        return

    if not completeTaskAllowed:
        return
    
    if selectedTask != null:
        selectedTask.reset()
        selectedTask = null

    selectedTask = task

    while not task.isSetup():
       
        receiveActiveChoice.call_deferred(task.ask())
        await Events.choiceMade
        
        if selectedTask != task:
            print('selected card abborted')
            return
    
    task.complete()
    Events.taskCompleted.emit(task)
    selectedTask = null
    activeTasks.erase(task)

    