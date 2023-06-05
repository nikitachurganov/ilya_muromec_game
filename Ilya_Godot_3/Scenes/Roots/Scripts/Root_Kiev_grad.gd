extends Node2D

func _ready():
	connect_player_to_death()
	#$World/YSort/StaticBody2D/Area2D.connect("talk", self, "quest_update")
	$World/YSort/StaticBody2D/CanvasLayer.connect("ttt", self, "quest_update")

func save():
	var data = {
		"filename": get_filename()
	}
	
	return data

func connect_player_to_death():
	var player = $World/YSort/Player
	player.connect("on_death", $HealthUI/Control, "set_death_screen", [])

func quest_update():
	$HealthUI/Control2.visible = true
	get_tree().paused = true
