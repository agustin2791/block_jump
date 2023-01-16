extends KinematicBody2D

signal update_points(points)
signal update_lives(lives)
signal update_countdown(count)
signal game_over

var running_towards := 'E'
export var speed := 600.0
export var in_the_air := false
var can_jump := false
export var jump_force := -1500.0
export var gravity := 10.0
var _velocity = Vector2.ZERO
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var air_timer = $AirTimer

var lives = 3
var drop = false
var can_drop = 4
var drop_position = Vector2(32.0, 432.0)
onready var drop_timer = $DropTimer
var total_points := 0
var is_respawn = false

func _ready():
	drop_timer.start()
	emit_signal("update_lives", lives)
	emit_signal("update_points", total_points)

func _physics_process(delta):
	if (Input.is_action_just_pressed("jump")) and !drop and can_drop <= 0:
		drop = true
	if !drop:
		return
	Movement(delta)
	if running_towards == 'E' and is_on_wall():
		running_towards = 'W'
		_velocity.x -= speed
	elif running_towards == 'W' and is_on_wall():
		running_towards = 'E'
		_velocity.x += speed
	if (Input.is_action_just_pressed("jump")) and (is_on_floor() or is_on_wall()):
		Jump(delta)

func Movement(delta):
	var dir = 0
	if running_towards == 'E':
		dir += 1
	else:
		dir -= 1
	_velocity.x += dir * speed * delta
	_velocity.y += gravity * delta
	_velocity = move_and_slide(_velocity, Vector2.UP)
	
	if is_on_floor():
		can_jump = true
		in_the_air = false
	
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group('bad'):
			if !is_respawn:
				is_respawn = true
				Restart()

func Jump(delta):
	in_the_air = true
	can_jump = false
	_velocity.y += jump_force

func Restart():
	global_position = drop_position
	drop = false
	can_drop = 4
	drop_timer.start()
	LoseStock()
	
func LoseStock():
	if lives - 1 < 0:
		GameOver()
	else:
		lives -= 1
		emit_signal("update_lives", lives)

func AddPoint():
	total_points += 1
	emit_signal("update_points", total_points)

func GameOver():
	if $'/root/Global'.last_best_score < total_points:
		$'/root/Global'.last_best_score = total_points
	emit_signal("game_over")
	get_tree().paused = true
	
func _on_DropTimer_timeout():
	can_drop -= 1
	if can_drop == 0:
		is_respawn = false
		emit_signal("update_countdown", 'Go!')
		drop_timer.stop()
	else:
		emit_signal("update_countdown", str(can_drop))
