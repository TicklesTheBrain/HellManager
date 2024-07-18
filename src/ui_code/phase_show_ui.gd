extends Node2D
class_name PhaseShowUI

@export var listOfPhases: Array[Globals.phases]
@export var listOfRects: Array[ColorRect]
@export var pointer: Polygon2D
@export var pointerMoveTime: float = 0.2

func _ready():
	Events.phaseStarted.connect(schedulePhaseShow)

func schedulePhaseShow(phase: Globals.phases):
	# print('scheduling phase ', phase)
	UIScheduler.addToSchedule(showPhase.bind(phase))

func showPhase(phase: Globals.phases):
	# print('showing phase ', phase)
	var index = listOfPhases.find(phase)
	var rect = listOfRects[index]
	var tween = get_tree().create_tween()
	var pos = rect.position + Vector2(rect.size.x / 2, rect.size.y)
	tween.tween_property(pointer, "position", pos, pointerMoveTime)
	await tween.finished
