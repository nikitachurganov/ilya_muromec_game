extends Node2D

export(String) var item_name = "Pie"
#export(String) var item_type

var item = ""

func set_item(item_name):
	$Sprite.texture = load("res://Art/Items/%s.png" % item_name)
	item = item_name

func _ready():
	set_item(item_name)

func get_item():
	return item

func _input(event):
	if event.is_action_pressed("ui_accept"):
		var pl = get_parent().get_parent().get_parent().get_player()
		if abs(pl.position.x - position.x) < 32 and abs(pl.position.y - position.y) < 32 and pl.inventory.size() < 15:
			get_parent().remove_child(self)
			pl.pick(self)

func save():
	var data = {
		"filename": get_filename(),
		"position": position,
		"item_name": item_name
	}
	
	return data


func load_from_data(data):
	position = data["position"]
	item_name = data["item_name"]
	set_item(item_name)






























