extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var animation_player = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("move")


func _on_Point_body_entered(body):
	if !body.is_in_group('bad'):
		body.AddPoint()
		queue_free()
