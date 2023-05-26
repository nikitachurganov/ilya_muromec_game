extends Node2D

func _ready():
	var count = 0
	for enemy in $World/YSort/Enemies.get_children():
		count += 1
	if count != 1:
		$SceenTransition/CollisionShape2D.disabled = true
	if count == 0:
		$SceenTransition/CollisionShape2D.disabled = false
	connect_player_to_death()
	start_quest()
	PlayerStats.connect("exp_changed", self, "enemy_quest")

func save():
	var data = {
		"filename": get_filename()
	}
	
	return data

func connect_player_to_death():
	var player = $World/YSort/Player
	$World/YSort/Player/HitboxPivot/SwordHitbox/CollisionShape2D.disabled = true
	player.connect("on_death", $HealthUI/Control, "set_death_screen", [])

func start_quest():
	if PlayerStats.quests[0] == "Отправиться в Чернигов":
		PlayerStats.quests.pop_front()
		$HealthUI/Control/Quest.quest_update()

func enemy_quest(value):
	var count = 0
	for enemy in $World/YSort/Enemies.get_children():
		count += 1
	print(count)
	if count == 1:
		if PlayerStats.quests[0] == "Победить татар":
			PlayerStats.quests.pop_front()
			$HealthUI/Control/Quest.quest_update()
			$SceenTransition/CollisionShape2D.set_deferred("disabled", false)
