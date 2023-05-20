extends Node2D

func _ready():
	$SceenTransition/CollisionShape2D.disabled = true
	connect_player_to_death()
	equip_quest()
	PlayerStats.connect("first_quest", self, "equip_quest")
	#connect("first_quest", PlayerStats, "equip_quest")
	#connect("first_quest", PlayerStats, "_on_first_quest")

func save():
	var data = {
		"filename": get_filename()
	}
	
	return data

func connect_player_to_death():
	var player = $World/YSort/Player
	player.connect("on_death", $HealthUI/Control, "set_death_screen", [])

func equip_quest():
	if PlayerStats.sword != "" and PlayerStats.armor != "" and PlayerStats.helmet != "" and PlayerStats.quests[0] == "set equipment":
		$SceenTransition/CollisionShape2D.disabled = false
		PlayerStats.quests.pop_front()
		$HealthUI/Control/Quest.quest_update()
