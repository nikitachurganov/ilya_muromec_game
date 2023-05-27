extends Node2D

func _ready():
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
	if PlayerStats.quests[0] == "Выйти из пещеры":
		PlayerStats.quests.pop_front()
		$HealthUI/Control/Quest.quest_update()
	elif PlayerStats.quests[0] == "Пройти топи":
		PlayerStats.quests.pop_front()
		PlayerStats.quests.pop_front()
		$HealthUI/Control/Quest.quest_update()
