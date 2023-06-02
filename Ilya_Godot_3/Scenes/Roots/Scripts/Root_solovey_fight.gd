extends Node2D

func _ready():
	connect_player_to_death()
	PlayerStats.connect("exp_changed", self, "enemy_quest")
	yield(get_tree().create_timer(0.8), "timeout")
	$CanvasLayer.start()

func save():
	var data = {
		"filename": get_filename()
	}
	
	return data

func connect_player_to_death():
	var player = $World/YSort/Player
	player.connect("on_death", $HealthUI/Control, "set_death_screen", [])

func enemy_quest(value):
	PlayerStats.quests.pop_front()
	yield(get_tree().create_timer(0.8), "timeout")
	$CanvasLayer2.start()
	$HealthUI/Control/Quest.quest_update()
	print(PlayerStats.quests[0])
