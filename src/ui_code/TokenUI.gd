extends TextureRect
class_name TokenUI

@export var types: Array[Token.Type]
@export var colors: Array[Color]
@export var tokenFadeTime: float
@export var token: Token:
	set (v):
		var index = types.find(v.type)
		self_modulate = colors[index]
		token = v
