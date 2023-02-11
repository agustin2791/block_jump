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
onready var countdown_player = $CountdownPlayer
var countdown_fx = load('res://assets/count_down.wav')
onready var timer = $Timer

var seconds := 0
var minutes := 0

onready var hero_block = $HeroBlock

var ad_viewed = false
onready var ad_reward = $AdMob
onready var ad_timer = $AdTimer

func _ready():
	rnd.randomize()
	AddNewPoint()
	timer.start()
	ad_reward.load_rewarded_video()
	
func AddNewPoint(total_points := 0):
	rnd.randomize()
	var new_point = rnd.randi_range(0, 7)
	
	while new_point == last_point_pos:
		new_point = rnd.randi_range(0, 7)
	print(new_point)
	var add_point = point.instance()
	add_point.global_position = point_locations[new_point]
	if total_points != 0 and total_points == $"/root/Global".last_best_score:
		add_point.modulate = '#faf73c'
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
	AddNewPoint(points)


func _on_HeroBlock_update_countdown(count):
	UpdateCountdownUI(count)
	animation_player.play("countdown")
	countdown_player.stream = countdown_fx
	countdown_player.play()


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
	ad_viewed = false
	get_node("CanvasLayer/Control/CenterContainer").visible = true
	get_node("CanvasLayer/Control/CenterContainer/VBoxContainer/PlayMore").visible = true
	get_node("CanvasLayer/Control/CenterContainer/VBoxContainer/Continue").visible = false


func _on_PlayMore_pressed():
#	ad_reward.load_rewarded_video()
	ad_reward.show_rewarded_video()
	var video_show = ad_reward.is_rewarded_video_loaded()


func _on_Continue_pressed():
	UpdateLivesUI(3)
	hero_block.lives = 3
	get_node("CanvasLayer/Control/CenterContainer").visible = false
	hero_block.ContinuePlay()

func _on_AdMob_rewarded_video_closed():
	get_node("CanvasLayer/Control/CenterContainer/VBoxContainer/PlayMore").visible = false
	get_node("CanvasLayer/Control/CenterContainer/VBoxContainer/Continue").visible = true
	ad_reward.load_rewarded_video()


func _on_AdTimer_timeout():
	ad_viewed = true


func _on_CountdownPlayer_finished():
	countdown_player.stop()
