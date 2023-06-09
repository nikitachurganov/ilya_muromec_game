extends Node2D

func _ready():
	connect_player_to_death()
	equip_quest()
	PlayerStats.connect("first_quest", self, "equip_quest")
	$World/YSort/SequrityMain/Area2D.connect("talk", self, "quest_update")

func save():
	var data = {
		"filename": get_filename()
	}
	
	return data

func connect_player_to_death():
	var player = $World/YSort/Player
	$World/YSort/Player/HitboxPivot/SwordHitbox/CollisionShape2D.disabled = true
	player.connect("on_death", $HealthUI/Control, "set_death_screen", [])

func equip_quest():
	if PlayerStats.quests[0] == "Войти в Чернигов":
		PlayerStats.quests.pop_front()
		$HealthUI/Control/Quest.quest_update()
		$SceenTransition/CollisionShape2D.disabled = true
	else:
		if PlayerStats.quests[0] == "Поговорить со стражниками":
			$SceenTransition/CollisionShape2D.disabled = true
		else:
			$SceenTransition/CollisionShape2D.disabled = false

func quest_update():
	$HealthUI/Control/Quest.quest_update()
	$SceenTransition/CollisionShape2D.disabled = false
