extends Control

var stats = PlayerStats
signal on_loaded(data)

func _ready():
	get_tree().paused = false
	$Buttons/Button.connect("pressed", self, "change_scene", [$Buttons/Button.scene_to_open])
	$Buttons/Button.connect("pressed", self, "new_game")
	
	$Buttons/Quit.connect("pressed", self, "quit")
	$Buttons/Resume.connect("pressed", self, "load_file")
	connect("on_loaded", SceneChanger, "load_game")

func change_scene(path):
	SceneChanger.change_scene(path)

func new_game():
	stats.max_health = 100
	stats.health = stats.max_health
	stats.max_exp = 500
	stats.experience = 0
	stats.inventory = []
	stats.atk = 10
	stats.def = 0
	stats.lvl = 1
	stats.position_x = 150
	stats.position_y = 150

func quit():
	get_tree().quit()

func load_file():
	var file_path = stats.save_dir.plus_file(stats.save_temp % "save")
	var file = File.new()
	
	if file.file_exists(file_path):
		var saved_game = load(file_path)
		#print(saved_game.get_saved_name())
		
		emit_signal("on_loaded", saved_game.get_data())