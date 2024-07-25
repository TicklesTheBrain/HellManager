extends ProtoCardUI
class_name TaskCardUI

@export var nameOfTask: Label
@export var taskText: Label
@export var taskConsequenceText: Label
@export var taskIcon: TextureRect
@export var animationPlayer: AnimationPlayer
@export var nextActivationLabel: Label

func _ready():
	# print('task card size ', $Background.size)
	await get_tree().create_timer(0.1).timeout
	# print('task card size ', $Background.size)

func updateCardUI():
	if card == null:
		return

	nameOfTask.text = card.cardName
	taskText.text = card.taskText
	taskConsequenceText.text = card.consequenceText
	taskIcon.texture = card.taskIcon
	nextActivationLabel.text = str(card.consequenceFrequency)

	Events.taskConsequenceStart.connect(func (t): if t == card: UIScheduler.addToSchedule(showPokeOut))
	Events.taskConsequenceEnd.connect(func (t): if t == card: UIScheduler.addToSchedule(showPokeBack))
	card.timerChanged.connect(processTimerChange)

func _on_background_gui_input(event:InputEvent):
	if event is InputEventMouseButton:
		if event.is_pressed():
			Events.taskCardClicked.emit(self, event.button_index)

func showNumberDecrease():
	animationPlayer.play("number_decrease")
	await animationPlayer.animation_finished

func showPokeOut():
	animationPlayer.play("poke_out")
	await animationPlayer.animation_finished

func showPokeBack():
	animationPlayer.play("poke_back")
	await animationPlayer.animation_finished

func processTimerChange(newValue: int):
	if int(nextActivationLabel.text) > newValue:
		UIScheduler.addToSchedule(func(): nextActivationLabel.text = str(newValue))
		UIScheduler.addToSchedule(showNumberDecrease)
	UIScheduler.addToSchedule(func(): nextActivationLabel.text = str(newValue))
	

