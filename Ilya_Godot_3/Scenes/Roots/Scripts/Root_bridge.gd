extends Node2D

func _ready():
	connect_player_to_death()
	start_quest()
	PlayerStats.connect("exp_changed", self, "enemy_quest")
	if PlayerStats.quests[0] == "Одолеть Змея Горыныча":
		$SceenTransition/CollisionShape2D.disabled = true

func save():
	var data = {
		"filename": get_filename()
	}
	
	return data

func connect_player_to_death():
	var player = $World/YSort/Player
	player.connect("on_death", $HealthUI/Control, "set_death_screen", [])

func start_quest():
	if PlayerStats.quests[0] == "Перейти Калиновый мост":
		PlayerStats.quests.pop_front()
		$HealthUI/Control/Quest.quest_update()

func enemy_quest(value):
	if PlayerStats.quests[0] == "Одолеть Змея Горыныча":
		PlayerStats.quests.pop_front()
		$HealthUI/Control/Quest.quest_update()
		$SceenTransition/CollisionShape2D.set_deferred("disabled", false)
