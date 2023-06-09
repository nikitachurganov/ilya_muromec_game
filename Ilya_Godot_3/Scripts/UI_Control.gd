extends Control

onready var pack = $NinePatchRect

func _ready():
	equipmentHood()
	PlayerStats.connect("equipment_changed", self, "equipmentHood")

func toggle_inventory(inventory):
	if pack.visible:
		$ColorRect.visible = false
		pack.visible = false
		get_tree().paused = false
	else:
		get_tree().paused = true
		$ColorRect.visible = true
		pack.visible = true
		pack.activeItem = null
		pack.show_inventory(inventory)

func update_inventory(inventory):
	if pack.visible:
		pack.show_inventory(inventory)

func set_death_screen():
	pack.hide()
	$DeathScreen.show()

func _unhandled_key_input(event):
	if event.is_action_pressed("esc"):
		if pack.visible:
			toggle_inventory(PlayerStats.inventory)
		else:
			$Menu.open()
	if event.is_action_pressed("inventory"):
		toggle_inventory(PlayerStats.inventory)

func equipmentHood():
	if PlayerStats.helmet == "":
		$VBoxContainer/Helmet.texture = null
	else:
		$VBoxContainer/Helmet.texture = load("res://Art/Items/%s.png" % PlayerStats.helmet)
	if PlayerStats.armor == "":
		$VBoxContainer/Armor.texture = null
	else:
		$VBoxContainer/Armor.texture = load("res://Art/Items/%s.png" % PlayerStats.armor)
	if PlayerStats.sword == "":
		$VBoxContainer/Sword.texture = null
	else:
		$VBoxContainer/Sword.texture = load("res://Art/Items/%s.png" % PlayerStats.sword)
