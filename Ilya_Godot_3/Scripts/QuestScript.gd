extends TextureRect

func _ready():
	#yield(SceneChanger, "on_game_ready")
	quest_update()


func quest_update():
	$Label.text = PlayerStats.quests[0]
