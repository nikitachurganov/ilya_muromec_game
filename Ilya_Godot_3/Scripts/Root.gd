extends Node2D

func _ready():
	var player = $World/YSort/Player
	player.connect("on_death", $HealthUI/Control, "set_death_screen", [])
