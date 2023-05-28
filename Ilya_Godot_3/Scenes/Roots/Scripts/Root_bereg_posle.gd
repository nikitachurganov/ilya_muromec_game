extends Node2D

func _ready():
	connect_player_to_death()

func save():
	var data = {
		"filename": get_filename()
	}
	
	return data

func connect_player_to_death():
	var player = $World/YSort/Player
	player.connect("on_death", $HealthUI/Control, "set_death_screen", [])

