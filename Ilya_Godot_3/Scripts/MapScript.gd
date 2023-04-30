extends Node2D

func get_player():
	return $YSort/Player

func _ready():
	add_to_group(PlayerStats.saving_group)
	SceneChanger.game_ready()
	$YSort/Player/Camera2D/Limits/BottomRight.position.x = 793
	$YSort/Player/Camera2D/Limits/BottomRight.position.y = 360
	$YSort/Player/Camera2D.current = true

func save():
	var data = {
		"filename": get_filename(),
		"player": $YSort/Player.save(),
		"path": get_parent().save(),
		"items": [],
		"objects": [],
		"enemy": []
	}
	
	for item in $YSort/Items.get_children():
		data["items"].append(item.save())
	
	for object in $YSort/Grass.get_children():
		data["objects"].append(object.save())
	
	for enemy in $YSort/Bats.get_children():
		data["enemy"].append(enemy.save())
	
	return data

func load_from_data(data):
	for item in $YSort/Items.get_children():
		$YSort/Items.remove_child(item)
		item.queue_free()
	
	for object in $YSort/Grass.get_children():
		$YSort/Grass.remove_child(object)
		object.queue_free()
	
	for enemy in $YSort/Bats.get_children():
		$YSort/Bats.remove_child(enemy)
		enemy.queue_free()
	
	var p =$YSort/Player
	PlayerStats.health = data["player"]["health"]
	PlayerStats.max_health = data["player"]["max_health"]
	PlayerStats.experience = data["player"]["experience"]
	PlayerStats.max_exp = data["player"]["max_exp"]
	PlayerStats.atk = data["player"]["atk"]
	PlayerStats.lvl = data["player"]["lvl"]
	PlayerStats.inventory = data["player"]["inventory"].duplicate(true)
	p.position = data["player"]["position"]
	PlayerStats.position_x = p.position.x
	PlayerStats.position_y = p.position.y
	
	#get_parent().connect_player_to_death()
	
	for i in data["items"]:
		var item = load(i["filename"]).instance()
		item.load_from_data(i)
		$YSort/Items.add_child(item)
	
	for i in data["objects"]:
		var object = load(i["filename"]).instance()
		$YSort/Grass.add_child(object)
		object.load_from_data(i)
	
	for i in data["enemy"]:
		var enemy = load(i["filename"]).instance()
		$YSort/Bats.add_child(enemy)
		enemy.load_from_data(i)













