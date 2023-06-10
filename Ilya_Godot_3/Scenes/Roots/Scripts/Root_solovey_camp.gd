extends Node2D

func _ready():
	if PlayerStats.quests[0] == "Поговорить с детьми Соловья":
		$SceenTransition/CollisionShape2D.disabled = true
	else:
		$SceenTransition/CollisionShape2D.disabled = false
	connect_player_to_death()
	$World/YSort/StaticBody2D/Area2D.connect("talk", self, "quest_update")

func save():
	var data = {
		"filename": get_filename()
	}
	
	return data

func connect_player_to_death():
	var player = $World/YSort/Player
	player.connect("on_death", $HealthUI/Control, "set_death_screen", [])

func quest_update():
	$HealthUI/Control/Quest.quest_update()
	print(PlayerStats.quests[0])
	$SceenTransition/CollisionShape2D.disabled = false
