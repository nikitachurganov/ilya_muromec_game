extends NinePatchRect

var activeItem = null
#var inventory = PlayerStats.inventory
onready var container = $HBoxContainer/GridContainer
onready var activeItemName = $HBoxContainer/Objects/Label
onready var activeItemPhoto = $HBoxContainer/Objects/ItemPhoto
onready var activeItemDescription = $HBoxContainer/Objects/Label2
var stats = PlayerStats

func _ready():
	visible = false

func show_inventory(inventory):
	if activeItem == null:
		activeItemName.text = ""
		activeItemPhoto.texture = null
		activeItemDescription.text = ""
		$HBoxContainer/Objects/HBoxContainer/Use.visible = false
		$HBoxContainer/Objects/HBoxContainer/Drop.visible = false
	else:
		$HBoxContainer/Objects/HBoxContainer/Use.visible = true
		$HBoxContainer/Objects/HBoxContainer/Drop.visible = true
		activeItemPhoto.texture = load("res://Art/Items/%s.png" % stats.inventory[activeItem])
		activeItemName.text = stats.inventory[activeItem]
		if stats.inventory[activeItem] == "Honey":
			activeItemDescription.text = "Heal +3"
		if stats.inventory[activeItem] == "Beaf":
			activeItemDescription.text = "Heal +2"
		if stats.inventory[activeItem] == "Calamari":
			activeItemDescription.text = "Heal +4"
		if stats.inventory[activeItem] == "Fish":
			activeItemDescription.text = "Heal +1"
		if stats.inventory[activeItem] == "Axe":
			activeItemDescription.text = "Def +5"
			if stats.helmet == "":
				$HBoxContainer/Objects/HBoxContainer/Drop.visible = false
		if stats.inventory[activeItem] == "BigSword":
			activeItemDescription.text = "ATK +5"
			if stats.sword == "":
				$HBoxContainer/Objects/HBoxContainer/Drop.visible = false
		if stats.inventory[activeItem] == "FortuneCookie":
			activeItemDescription.text = "Def +5"
			if stats.armor == "":
				$HBoxContainer/Objects/HBoxContainer/Drop.visible = false
	
	var count = 0
	for item in $HBoxContainer/GridContainer.get_children():
		if inventory.size() < count + 1:
			item.get_children()[0].texture = null
		else:
			item.get_children()[0].texture = load("res://Art/Items/%s.png" % inventory[count])
			count += 1

func activeItemChoose(count):
	if stats.inventory.size() >= count + 1:
		activeItem = count
	else:
		activeItem = null

func _on_Use_button_down():
	$HBoxContainer/Objects/HBoxContainer/Use/Label.rect_position.x += 1
	$HBoxContainer/Objects/HBoxContainer/Use/Label.rect_position.y += 1
	if stats.inventory[activeItem] == "Honey":
		stats.HP_replenishment(3)
		update_inventory()
	elif stats.inventory[activeItem] == "Beaf":
		stats.HP_replenishment(2)
		update_inventory()
	elif stats.inventory[activeItem] == "Calamari":
		stats.HP_replenishment(4)
		update_inventory()
	elif stats.inventory[activeItem] == "Fish":
		stats.HP_replenishment(1)
		update_inventory()
	elif stats.inventory[activeItem] == "Axe":
		stats.set_equipment("Axe")
		update_inventory()
	elif stats.inventory[activeItem] == "BigSword":
		stats.set_equipment("BigSword")
		update_inventory()
	elif stats.inventory[activeItem] == "FortuneCookie":
		stats.set_equipment("FortuneCookie")
		update_inventory()
	show_inventory(stats.inventory)

func _on_Use_button_up():
	$HBoxContainer/Objects/HBoxContainer/Use/Label.rect_position.x -= 1
	$HBoxContainer/Objects/HBoxContainer/Use/Label.rect_position.y -= 1

func _on_Drop_button_down():
	$HBoxContainer/Objects/HBoxContainer/Drop/Label.rect_position.x += 1
	$HBoxContainer/Objects/HBoxContainer/Drop/Label.rect_position.y += 1
	stats.inventory.remove(activeItem)
	activeItem = null
	show_inventory(stats.inventory)

func _on_Drop_button_up():
	$HBoxContainer/Objects/HBoxContainer/Drop/Label.rect_position.x -= 1
	$HBoxContainer/Objects/HBoxContainer/Drop/Label.rect_position.y -= 1

func update_inventory():
	stats.inventory.remove(activeItem)
	activeItem = null
