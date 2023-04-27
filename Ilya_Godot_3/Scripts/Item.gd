extends Node2D

export(String) var item_name
#export(String) var item_type

var item = ""

func set_item(item_name):
	$Sprite.texture = load("res://Art/Items/Food/%s.png" % item_name)
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
