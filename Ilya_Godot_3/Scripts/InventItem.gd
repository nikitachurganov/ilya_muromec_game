extends TextureRect

func set_item(item_name):
	texture = load("res://Art/Items/Food/%s.png" % item_name)
