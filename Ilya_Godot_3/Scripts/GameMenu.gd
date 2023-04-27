extends Control

onready var save_file = preload("res://Scripts/Recources/SaveData.gd")

signal on_saved

func _ready():
	hide()
	$Panel/Main/Buttons/Resume.connect("pressed", self, "open")
	$Panel/Main/Buttons/Quit.connect("pressed", SceneChanger, "change_scene", ["res://UI/Menu.tscn"])
	$Panel/Main/Buttons/Save.connect("pressed", self, "save")

func open():
	if visible:
		hide()
		get_tree().paused = false
	else:
		get_tree().paused = true
		show()
		$Panel/Main.show()

func update_saves():
	var dir = Directory.new()
	if not dir.dir_exists(PlayerStats.save_dir):
		dir.make_dir_recursive(PlayerStats.save_dir)
	dir.change_dir(PlayerStats.save_dir)

func save():
	var dir = Directory.new()
	if not dir.dir_exists(PlayerStats.save_dir):
		dir.make_dir_recursive(PlayerStats.save_dir)
	dir.change_dir(PlayerStats.save_dir)
	
	var file = save_file.new()
	var save_path = PlayerStats.save_dir.plus_file(PlayerStats.save_temp % "save")
	
	ResourceSaver.save(save_path, file)
	emit_signal("on_saved")
