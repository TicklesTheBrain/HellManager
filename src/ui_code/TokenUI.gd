extends Control
class_name TokenUI

@export var types: Array[Token.Type]
@export var colors: Array[Color]
@export var icon: Array[Texture]
@export var icon_modulate: Array[Color]
@export var tokenFadeTime: float
@export var shapeRect: TextureRect
@export var iconRect: TextureRect

@export var token: Token:
	set (v):
		var index = types.find(v.type)
		shapeRect.self_modulate = colors[index]
		if icon[index] != null:
			iconRect.visible = true
			iconRect.texture = icon[index]
			iconRect.self_modulate = icon_modulate[index]
		token = v
