extends Control

func set_item(item_name):
	$Box/Texture.texture = load("res://Art/Items/%s.png" % item_name)
