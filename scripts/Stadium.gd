extends Node2D

var point_locations = [
	Vector2(510.0, 328.0),
	Vector2(144.0, 424.0),
	Vector2(224.0, 224.0),
	Vector2(792.0, 232.0),
	Vector2(864.0, 424.0),
	Vector2(176.0, 533.0),
	Vector2(507.0, 533.0),
	Vector2(864.0, 533.0),
]

var last_point_pos = 0

var point = preload("res://scenes/Point.tscn")

var rnd = RandomNumberGenerator.new()
onready var animation_player = $AnimationPlayer

onready var timer = $Timer

var seconds := 0
var minutes := 0

func _ready():
	rnd.randomize()
	AddNewPoint()
	timer.start()
	
func AddNewPoint():
	rnd.randomize()
	var new_point = rnd.randi_range(0, 7)
	
	while new_point == last_point_pos:
		new_point = rnd.randi_range(0, 7)
	print(new_point)
	var add_point = point.instance()
	add_point.global_position = point_locations[new_point]
	add_child(add_point)
	last_point_pos = new_point

func UpdateLivesUI(lives):
	get_node("CanvasLayer/Control/VBoxContainer/Lives/HBoxContainer/lives_count").text = str(lives)
	
func UpdatePointsUI(points):
	get_node("CanvasLayer/Control/VBoxContainer/Lives/HBoxContainer2/points_count").text = str(points)

func UpdateCountdownUI(count):
	get_node("CanvasLayer/Control/Countdown").text = str(count)
	
func _on_HeroBlock_update_lives(lives):
	print('setting lives')
	UpdateLivesUI(lives)


func _on_HeroBlock_update_points(points):
	print('setting points')
	UpdatePointsUI(points)
	AddNewPoint()


func _on_HeroBlock_update_countdown(count):
	UpdateCountdownUI(count)
	animation_player.play("countdown")


func _on_Timer_timeout():
	if seconds + 1 == 60:
		minutes += 1
		seconds = 0
	else:
		seconds += 1
	var real_sec = '0' + str(seconds) if seconds < 10 else str(seconds)
	get_node("CanvasLayer/Control/VBoxContainer/Lives/HBoxContainer3/minutes").text = str(minutes)
	get_node("CanvasLayer/Control/VBoxContainer/Lives/HBoxContainer3/seconds").text = str(real_sec)


func _on_BackButton_pressed():
	get_tree().change_scene("res://scenes/menus/MainMenu.tscn")


func _on_HeroBlock_game_over():
	get_node("CanvasLayer/Control/BackButton").visible = true
