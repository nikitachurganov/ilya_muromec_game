extends Node2D

func _ready():
	connect_player_to_death()
	equip_quest()
	PlayerStats.connect("first_quest", self, "equip_quest")
	$World/YSort/Babka/Area2D.connect("talk", self, "quest_update")

func save():
	var data = {
		"filename": get_filename()
	}
	
	return data

func connect_player_to_death():
	var player = $World/YSort/Player
	player.connect("on_death", $HealthUI/Control, "set_death_screen", [])

func equip_quest():
	if PlayerStats.quests[0] == "Выйти из дома":
		PlayerStats.quests.pop_front()
		quest_update()
		if PlayerStats.quests[0] == "Поговорить с родителями":
			$SceenTransition/CollisionShape2D.disabled = true

func quest_update():
	$HealthUI/Control/Quest.quest_update()
	$SceenTransition/CollisionShape2D.disabled = false
