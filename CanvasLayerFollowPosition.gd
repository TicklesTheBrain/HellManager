extends CanvasLayer
class_name CanvasLayerFollowPosition

@export var nodeForFollowPosition: Node2D

func _process(_delta):
    if nodeForFollowPosition != null:
        offset = nodeForFollowPosition.position