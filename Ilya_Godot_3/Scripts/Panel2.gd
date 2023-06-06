extends NinePatchRect

var activeItem = null
var stats = PlayerStats

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
		#activeItemName.text = stats.inventory[activeItem]["name"]
		activeItemName.text = stats.items[stats.inventory[activeItem]]["name"]
		if stats.items[stats.inventory[activeItem]]["type"] == "food":
			activeItemDescription.text = "+%s к здровью" % stats.items[stats.inventory[activeItem]]["heal"]
		if stats.items[stats.inventory[activeItem]]["type"] == "armor":
			activeItemDescription.text = "+%s к защите" % stats.items[stats.inventory[activeItem]]["def"]
			if stats.armor == "":
				$HBoxContainer/Objects/HBoxContainer/Drop.visible = false
		if stats.items[stats.inventory[activeItem]]["type"] == "sword":
			activeItemDescription.text = "+%s к атаке" % stats.items[stats.inventory[activeItem]]["attack"]
			if stats.sword == "":
				$HBoxContainer/Objects/HBoxContainer/Drop.visible = false
		if stats.items[stats.inventory[activeItem]]["type"] == "helmet":
			activeItemDescription.text = "+%s к защите" % stats.items[stats.inventory[activeItem]]["def"]
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
	if stats.items[stats.inventory[activeItem]]["type"] == "food":
		stats.HP_replenishment(stats.items[stats.inventory[activeItem]]["heal"])
	elif stats.items[stats.inventory[activeItem]]["type"] == "armor" or stats.items[stats.inventory[activeItem]]["type"] == "helmet" or stats.items[stats.inventory[activeItem]]["type"] == "sword":
		stats.set_equipment(stats.inventory[activeItem])
	update_inventory()
	show_inventory(stats.inventory)
	if !$HBoxContainer/Objects/HBoxContainer/Use/AudioStreamPlayer.is_playing():
		$HBoxContainer/Objects/HBoxContainer/Use/AudioStreamPlayer.play()

func _on_Use_button_up():
	$HBoxContainer/Objects/HBoxContainer/Use/Label.rect_position.x -= 1
	$HBoxContainer/Objects/HBoxContainer/Use/Label.rect_position.y -= 1

func _on_Drop_button_down():
	$HBoxContainer/Objects/HBoxContainer/Drop/Label.rect_position.x += 1
	$HBoxContainer/Objects/HBoxContainer/Drop/Label.rect_position.y += 1
	if !$HBoxContainer/Objects/HBoxContainer/Use/AudioStreamPlayer.is_playing():
		$HBoxContainer/Objects/HBoxContainer/Use/AudioStreamPlayer.play()
	stats.inventory.remove(activeItem)
	activeItem = null
	show_inventory(stats.inventory)

func _on_Drop_button_up():
	$HBoxContainer/Objects/HBoxContainer/Drop/Label.rect_position.x -= 1
	$HBoxContainer/Objects/HBoxContainer/Drop/Label.rect_position.y -= 1

func update_inventory():
	stats.inventory.remove(activeItem)
	activeItem = null


func _on_Use_mouse_entered():
	$HBoxContainer/Objects/HBoxContainer/Use/AudioStreamPlayer.play()


func _on_Drop_mouse_entered():
	$HBoxContainer/Objects/HBoxContainer/Use/AudioStreamPlayer.play()
