extends KinematicBody2D

var running_towards := 'E'
export var speed := 600.0
export var in_the_air := false
var can_jump := false
export var jump_force := -1500.0
export var gravity := 10.0
var _velocity = Vector2.ZERO


func _physics_process(delta):
	Movement(delta)
	if running_towards == 'E' and is_on_wall():
		running_towards = 'W'
		_velocity.x -= speed
	elif running_towards == 'W' and is_on_wall():
		running_towards = 'E'
		_velocity.x += speed


func Movement(delta):
	var dir = 0
	if running_towards == 'E':
		dir += 1
	else:
		dir -= 1
	_velocity.x += dir * speed * delta
	_velocity.y += gravity * delta
	_velocity = move_and_slide(_velocity, Vector2.UP)


