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
		if stats.inventory[activeItem] == "Pie":
			activeItemDescription.text = "Heal +3"
		if stats.inventory[activeItem] == "Milk":
			activeItemDescription.text = "Heal +5"
		if stats.inventory[activeItem] == "Apple":
			activeItemDescription.text = "Heal +2"
		if stats.inventory[activeItem] == "Armor1":
			activeItemDescription.text = "Def +2"
			if stats.armor == "":
				$HBoxContainer/Objects/HBoxContainer/Drop.visible = false
		if stats.inventory[activeItem] == "Armor2":
			activeItemDescription.text = "Def +5"
			if stats.armor == "":
				$HBoxContainer/Objects/HBoxContainer/Drop.visible = false
		if stats.inventory[activeItem] == "Armor3":
			activeItemDescription.text = "Def +10"
			if stats.armor == "":
				$HBoxContainer/Objects/HBoxContainer/Drop.visible = false
		if stats.inventory[activeItem] == "Sword1":
			activeItemDescription.text = "ATK +2"
			if stats.sword == "":
				$HBoxContainer/Objects/HBoxContainer/Drop.visible = false
		if stats.inventory[activeItem] == "Sword2":
			activeItemDescription.text = "ATK +5"
			if stats.sword == "":
				$HBoxContainer/Objects/HBoxContainer/Drop.visible = false
		if stats.inventory[activeItem] == "Sword3":
			activeItemDescription.text = "ATK +10"
			if stats.sword == "":
				$HBoxContainer/Objects/HBoxContainer/Drop.visible = false
		if stats.inventory[activeItem] == "Helmet1":
			activeItemDescription.text = "Def +2"
			if stats.helmet == "":
				$HBoxContainer/Objects/HBoxContainer/Drop.visible = false
		if stats.inventory[activeItem] == "Helmet2":
			activeItemDescription.text = "Def +5"
			if stats.helmet == "":
				$HBoxContainer/Objects/HBoxContainer/Drop.visible = false
		if stats.inventory[activeItem] == "Helmet3":
			activeItemDescription.text = "Def +10"
			if stats.helmet == "":
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
	if stats.inventory[activeItem] == "Pie":
		stats.HP_replenishment(3)
	elif stats.inventory[activeItem] == "Milk":
		stats.HP_replenishment(5)
	elif stats.inventory[activeItem] == "Apple":
		stats.HP_replenishment(2)
	elif stats.inventory[activeItem] == "Armor1":
		stats.set_equipment("Armor1")
	elif stats.inventory[activeItem] == "Armor2":
		stats.set_equipment("Armor2")
	elif stats.inventory[activeItem] == "Armor3":
		stats.set_equipment("Armor3")
	elif stats.inventory[activeItem] == "Sword1":
		stats.set_equipment("Sword1")
	elif stats.inventory[activeItem] == "Sword2":
		stats.set_equipment("Sword2")
	elif stats.inventory[activeItem] == "Sword3":
		stats.set_equipment("Sword3")
	elif stats.inventory[activeItem] == "Helmet1":
		stats.set_equipment("Helmet1")
	elif stats.inventory[activeItem] == "Helmet2":
		stats.set_equipment("Helmet2")
	elif stats.inventory[activeItem] == "Helmet3":
		stats.set_equipment("Helmet3")
	update_inventory()
	show_inventory(stats.inventory)

func _on_Use_button_up():
	$HBoxContainer/Objects/HBoxContainer/Use/Label.rect_position.x -= 1
	$HBoxContainer/Objects/HBoxContainer/Use/Label.rect_position.y -= 1
	print(stats.helmet, stats.armor, stats.sword)

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
