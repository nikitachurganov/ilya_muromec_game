extends Node2D

func _ready():
	$SceenTransition/CollisionShape2D.disabled = true
	connect_player_to_death()
	PlayerStats.connect("exp_changed", self, "enemy_quest")

func save():
	var data = {
		"filename": get_filename()
	}
	
	return data

func connect_player_to_death():
	var player = $World/YSort/Player
	player.connect("on_death", $HealthUI/Control, "set_death_screen", [])

func enemy_quest(value):
	var count = 0
	for enemy in $World/YSort/Bats.get_children():
		count += 1
	print(count)
	if count == 1:
		$SceenTransition/CollisionShape2D.set_deferred("disabled", false)

