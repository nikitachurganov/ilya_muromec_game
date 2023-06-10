extends Node2D

onready var save_file = preload("res://Scripts/Recources/SaveData.gd")

signal on_saved
signal talk

func get_player():
	return $YSort/Player

func _ready():
	add_to_group(PlayerStats.saving_group)
	SceneChanger.game_ready()
	$YSort/Player/Camera2D.current = true
	save_start()

func save_start():
	var dir = Directory.new()
	if not dir.dir_exists(PlayerStats.save_dir):
		dir.make_dir_recursive(PlayerStats.save_dir)
	dir.change_dir(PlayerStats.save_dir)
	
	var file = save_file.new()
	var able_to_save = get_tree().get_nodes_in_group(PlayerStats.saving_group)
	file.set_data(able_to_save[0].save())
	var save_path = PlayerStats.save_dir.plus_file(PlayerStats.save_temp % "save")
	
	ResourceSaver.save(save_path, file)
	emit_signal("on_saved")

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
	
	for object in $YSort/Objects.get_children():
		data["objects"].append(object.save())
	
	for enemy in $YSort/Enemies.get_children():
		data["enemy"].append(enemy.save())
	
	return data

func load_from_data(data):
	for item in $YSort/Items.get_children():
		$YSort/Items.remove_child(item)
		item.queue_free()
	
	for object in $YSort/Objects.get_children():
		$YSort/Objects.remove_child(object)
		object.queue_free()
	
	for enemy in $YSort/Enemies.get_children():
		$YSort/Enemies.remove_child(enemy)
		enemy.queue_free()
	
	var p = $YSort/Player
	p.load_from_data(data)
	
	for i in data["items"]:
		var item = load(i["filename"]).instance()
		item.load_from_data(i)
		$YSort/Items.add_child(item)
	
	for i in data["objects"]:
		var object = load(i["filename"]).instance()
		$YSort/Objects.add_child(object)
		object.load_from_data(i)
	
	for i in data["enemy"]:
		var enemy = load(i["filename"]).instance()
		$YSort/Enemies.add_child(enemy)
		enemy.load_from_data(i)


func _on_Area2D_area_entered(area):
	if PlayerStats.quests[0] == "Пройти пещеру":
		PlayerStats.quests.pop_front()
		emit_signal("talk")
		$CanvasLayer.start()
		print(PlayerStats.quests[0])


