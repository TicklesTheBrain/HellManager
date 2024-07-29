extends Node2D
class_name CompanyGridCell

@export var highlightPanel: Panel
@export var outlinePanel: Panel 
var highlight: bool = false
var jobUI: JobUI = null

func highlightOn():
	highlightPanel.visible = true
	highlight = true

func highlightOff():
	highlightPanel.visible = false
	highlight = false

func gridOn():
	outlinePanel.visible = true

func gridOff():
	outlinePanel.visible = false

func getSize():
	return highlightPanel.size
