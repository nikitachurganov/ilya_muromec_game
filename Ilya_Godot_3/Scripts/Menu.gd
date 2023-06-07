extends Control

#проверка
var stats = PlayerStats
signal on_loaded(data)

func _ready():
	
	get_tree().paused = false
	if File.new().file_exists(stats.save_dir.plus_file(stats.save_temp % "save")):
		$Buttons/Resume.visible = true
	else:
		$Buttons/Resume.visible = false
	
	$Buttons/Button.connect("pressed", self, "change_scene", [$Buttons/Button.scene_to_open])
	$Buttons/Button.connect("pressed", self, "new_game")
	
	$Buttons/Quit.connect("pressed", self, "quit")
	$Buttons/Resume.connect("pressed", self, "load_file")
	connect("on_loaded", SceneChanger, "load_game")


func change_scene(path):
	SceneChanger.change_scene(path)

func new_game():
	stats.helmet = ""
	stats.armor = ""
	stats.sword = ""
	stats.max_health = 100
	stats.health = stats.max_health
	stats.max_exp = 500
	stats.experience = 0
	stats.inventory = []
	stats.atk = 10
	stats.def = 0
	stats.lvl = 1
	stats.position_x = 53
	stats.position_y = 78
	stats.quests = ["Надеть экипировку", 
					"Выйти из дома",
					"Поговорить с родителями",
					"Отправиться в Чернигов", 
					"Победить татар", 
					"Войти в Чернигов",
					"Поговорить со стражниками",
					"Выйти из Чернигова",
					"Пройти топи",
					"Пройти пещеру",
					"Одолеть Тугарина",
					"Выйти из пещеры",
					"Перейти Калиновый мост",
					"Одолеть Змея Горыныча",
					"Одолеть Соловья-разбойника",
					"Поговорить с детьми Соловья",
					"Поговорить с Князем"]

func quit():
	get_tree().quit()

func load_file():
	PlayerStats.helmet = ""
	PlayerStats.armor = ""
	PlayerStats.sword = ""
	var file_path = stats.save_dir.plus_file(stats.save_temp % "save")
	var file = File.new()
	
	if file.file_exists(file_path):
		var saved_game = load(file_path)
		
		emit_signal("on_loaded", saved_game.get_data())


func _on_Quit_button_down():
	$Buttons/Quit/Label.rect_position.x += 1
	$Buttons/Quit/Label.rect_position.y += 1


func _on_Quit_button_up():
	$Buttons/Quit/Label.rect_position.x -= 1
	$Buttons/Quit/Label.rect_position.y -= 1

