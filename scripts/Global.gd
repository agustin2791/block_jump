extends Node2D
onready var main_audio = $AudioStreamPlayer2D
#var track_1 = load()
var _music_bus = AudioServer.get_bus_index('Music')
var _fx_bus = AudioServer.get_bus_index('FX')
var last_best_score := 0

func _ready():
	pause_mode = false
