extends CanvasLayer

export(String, FILE, "*.json") var d_file
export(String) var otherDudeTexture = ""

var dialogue = []
var current_dialogue_id = 0
var d_active = false

signal ttt

func _ready():
	$NinePatchRect.visible = false
	$ColorRect.visible = false
	$IlyaMuromets.visible = false
	$OtherDude.texture = load(otherDudeTexture)
	$OtherDude.visible = false

func start():
	if d_active:
		return
	d_active = true
	$NinePatchRect.visible = true
	$ColorRect.visible = true
	$IlyaMuromets.visible = true
	$OtherDude.visible = true
	
	dialogue = laod_dialogue()
	current_dialogue_id = -1
	next_script()
	get_parent().get_tree().paused = true

func laod_dialogue():
	var file = File.new()
	if file.file_exists(d_file):
		file.open(d_file, file.READ)
		return parse_json(file.get_as_text())

func _input(event):
	if not d_active:
		return
	if event.is_action_pressed("esc"):
		$Timer.start()
		$NinePatchRect.visible = false
		$ColorRect.visible = false
		$IlyaMuromets.visible = false
		$OtherDude.visible = false
		return
	if event.is_action_pressed("ui_accept"):
		next_script()

func next_script():
	current_dialogue_id += 1
	
	if current_dialogue_id >= len(dialogue):
		$Timer.start()
		$NinePatchRect.visible = false
		$ColorRect.visible = false
		$IlyaMuromets.visible = false
		$OtherDude.visible = false
		return
	
	if dialogue[current_dialogue_id]["name"] == "Илья Муромец":
		$IlyaMuromets.modulate.a = 1
		$OtherDude.modulate.a = 0.5
	else:
		$IlyaMuromets.modulate.a = 0.5
		$OtherDude.modulate.a = 1
	
	$NinePatchRect/Name.text = dialogue[current_dialogue_id]["name"] 
	$NinePatchRect/Chat.text = dialogue[current_dialogue_id]["text"] 


func _on_Timer_timeout():
	get_parent().get_tree().paused = false
	d_active = false
	emit_signal("ttt")
