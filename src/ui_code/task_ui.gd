extends Control
class_name TaskUI

@export var nameOfTask: Label
@export var taskText: Label
@export var taskConsequenceText: Label
@export var task: Task:
	set(v):
		task = v
		updateTaskUI()
@export var taskIcon: TextureRect

func updateTaskUI():
	if task == null:
		return

	nameOfTask.text = task.taskName
	taskText.text = task.taskText
	taskConsequenceText.text = task.consequenceText
	taskIcon.texture = task.taskIcon

func _on_background_gui_input(event:InputEvent):
	if event is InputEventMouseButton:
		if event.is_pressed():
			Events.taskClicked.emit(self, event.button_index)