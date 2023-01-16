extends Control

func _ready():
	get_tree().paused = false
	get_node("CenterContainer/VBoxContainer/LastScore").text = 'Best Score: ' + str($"/root/Global".last_best_score)

func _on_PlayButton_pressed():
	get_tree().change_scene("res://scenes/Stadium.tscn")
