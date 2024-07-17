extends Line2D
class_name FlowLineUI

@export var from: Job
@export var to: Job
@export var fromUI: JobUI:
	set(v):
		fromUI = v
		updateLine()
@export var toUI: JobUI:
	set(v):
		toUI = v
		updateLine()

func _ready():
	fromUI.moved.connect(updateLine)
	toUI.moved.connect(updateLine)
	Events.jobDestroyed.connect(func(j):
		if j == from or j == to:
			queue_free()
		)

func updateLine():
	if fromUI == null or toUI == null or from == null or to == null:
		#print('line setup, something went wrong')
		return

	var toIndex: int = to.inflow.find(from)
	var fromIndex: int = from.outflow.find(to)
	var fromPos: Vector2 = fromUI.outMarkers[fromIndex].global_position
	var toPos: Vector2 = toUI.inMarkers[toIndex].global_position

	#print('new line ', fromIndex, '  ', toIndex)
	points[0] = fromPos
	points[1] = toPos
