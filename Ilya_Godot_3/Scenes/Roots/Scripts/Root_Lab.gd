extends Node2D

func _ready():
	#$SceenTransition/CollisionShape2D.disabled = true
	connect_player_to_death()
	equip_quest()
	PlayerStats.connect("first_quest", self, "equip_quest")

func save():
	var data = {
		"filename": get_filename()
	}
	
	return data

func connect_player_to_death():
	var player = $World/YSort/Player
	player.connect("on_death", $HealthUI/Control, "set_death_screen", [])

func equip_quest():
	if PlayerStats.quests[0] == "Выйти из Чернигова":
		PlayerStats.quests.pop_front()
		$HealthUI/Control/Quest.quest_update()
