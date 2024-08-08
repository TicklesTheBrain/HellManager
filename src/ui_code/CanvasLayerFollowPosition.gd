extends Node2D
class_name FollowPositionNode

@export var nodeForFollowPosition: Node2D

func _process(_delta):
    if nodeForFollowPosition != null:
        position = nodeForFollowPosition.position