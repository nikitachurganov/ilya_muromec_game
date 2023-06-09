extends NinePatchRect

onready var item = preload("res://Scenes/InventItem.tscn")
onready var container = $Box/GridContainer

func _ready():
	clear()
	visible = false

func clear():
	for i in container.get_children():
		container.remove_child(i)
		i.queue_free()

func show_inventory(inventory):
	clear()
	for i in inventory:
		var new_item = item.instance()
		container.add_child(new_item)
		new_item.set_item(i)
