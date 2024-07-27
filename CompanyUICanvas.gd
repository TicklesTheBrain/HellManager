extends Node2D
class_name CompanyUICanvas

@export var background: ColorRect
@export var collisionShape: CollisionShape2D
@export var initialSize: Vector2

var myStartPosition: Vector2
var currentSize: Vector2
var drag: bool = false

func _ready():
	makeSize(initialSize)
	myStartPosition = position

func _on_drag_area_company_ui_input_event(viewport:Node, event:InputEvent, _shape_idx:int):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		Events.companyCanvasDragStart.emit(self)
	if event is InputEventMouseButton and event.is_released() and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		Events.companyCanvasDragReleased.emit(self)
	if event is InputEventMouseMotion and drag:
		adjustDrag(event.relative, viewport)


	pass # Replace with function body.

func makeSize(size: Vector2):
	background.size = size
	collisionShape.shape.size = size
	collisionShape.position = size/2
	currentSize = size

func adjustDrag(dragAmount: Vector2, viewport: Viewport):
	var viewportSize = viewport.get_visible_rect().size
	# print('viewportSize ', viewportSize)
	position += dragAmount
	position.x = clamp(position.x, (currentSize.x - viewportSize.x)*-1, myStartPosition.x)
	position.y = clamp(position.y, (currentSize.y - viewportSize.y)*-1, myStartPosition.y)


