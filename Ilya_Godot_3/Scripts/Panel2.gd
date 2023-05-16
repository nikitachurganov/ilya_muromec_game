extends NinePatchRect

var activeItem = null
var stats = PlayerStats

var items = {
	"Helmet1": {"def": 2, "type": "helmet"},
	"Helmet2": {"def": 5, "type": "helmet"},
	"Helmet3": {"def": 10, "type": "helmet"},
	"Sword1": {"atk": 2, "type": "sword"},
	"Sword2": {"atk": 5, "type": "sword"},
	"Sword3": {"atk": 10, "type": "sword"},
	"Armor1": {"def": 2, "type": "armor"},
	"Armor2": {"def": 5, "type": "armor"},
	"Armor3": {"def": 10, "type": "armor"},
	"Milk": {"heal": 5, "type": "food"},
	"Apple": {"heal": 2, "type": "food"},
	"Pie": {"heal": 3, "type": "food"}
}

func _ready():
	visible = false

func show_inventory(inventory):
	var activeItemName = $HBoxContainer/Objects/Label
	var activeItemPhoto = $HBoxContainer/Objects/ItemPhoto
	var activeItemDescription = $HBoxContainer/Objects/Label2
	
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
		if items[stats.inventory[activeItem]]["type"] == "food":
			activeItemDescription.text = "Heal +%s" % items[stats.inventory[activeItem]]["heal"]
		if items[stats.inventory[activeItem]]["type"] == "armor":
			activeItemDescription.text = "DEF +%s" % items[stats.inventory[activeItem]]["def"]
			if stats.armor == "":
				$HBoxContainer/Objects/HBoxContainer/Drop.visible = false
		if items[stats.inventory[activeItem]]["type"] == "sword":
			activeItemDescription.text = "ATK +%s" % items[stats.inventory[activeItem]]["atk"]
			if stats.sword == "":
				$HBoxContainer/Objects/HBoxContainer/Drop.visible = false
		if items[stats.inventory[activeItem]]["type"] == "helmet":
			activeItemDescription.text = "DEF +%s" % items[stats.inventory[activeItem]]["def"]
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
	if items[stats.inventory[activeItem]]["type"] == "food":
		stats.HP_replenishment(items[stats.inventory[activeItem]]["heal"])
	elif items[stats.inventory[activeItem]]["type"] == "armor" or items[stats.inventory[activeItem]]["type"] == "helmet" or items[stats.inventory[activeItem]]["type"] == "sword":
		stats.set_equipment(stats.inventory[activeItem])
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
