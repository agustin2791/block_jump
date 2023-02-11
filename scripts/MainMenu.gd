extends Control
onready var ad_mob = $AdMob

func _ready():
	ad_mob.load_banner()
	ad_mob.show_banner()
	get_tree().paused = false
	get_node("CenterContainer/VBoxContainer/LastScore").text = 'Best Score: ' + str($"/root/Global".last_best_score)

func _on_PlayButton_pressed():
	ad_mob.hide_banner()
	get_tree().change_scene("res://scenes/Stadium.tscn")
