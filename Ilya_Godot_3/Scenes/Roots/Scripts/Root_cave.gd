extends Node2D

func _ready():
	connect_player_to_death()
	start_quest()
	PlayerStats.connect("exp_changed", self, "enemy_quest")
	if PlayerStats.quests[0] == "Одолеть Тугарина":
		$SceenTransition/CollisionShape2D.disabled = true
	else:
		$SceenTransition/CollisionShape2D.disabled = false
	$World.connect("talk", self, "quest_update")

func save():
	var data = {
		"filename": get_filename()
	}
	
	return data

func connect_player_to_death():
	var player = $World/YSort/Player
	player.connect("on_death", $HealthUI/Control, "set_death_screen", [])

func start_quest():
	if PlayerStats.quests[0] == "Пройти топи":
		PlayerStats.quests.pop_front()
		$HealthUI/Control/Quest.quest_update()

func enemy_quest(value):
	if PlayerStats.quests[0] == "Одолеть Тугарина":
		PlayerStats.quests.pop_front()
		$HealthUI/Control/Quest.quest_update()
		$SceenTransition/CollisionShape2D.set_deferred("disabled", false)

func quest_update():
	$HealthUI/Control/Quest.quest_update()
