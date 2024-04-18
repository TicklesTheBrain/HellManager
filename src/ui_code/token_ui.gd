extends TextureRect

@export var types: Array[Token.Type]
@export var colors: Array[Color]
@export var type: Token.Type:
	set (v):
		var index = types.find(v)
		self_modulate = colors[index]
		type = v