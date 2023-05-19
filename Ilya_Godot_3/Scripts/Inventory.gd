extends Control

onready var items = []

func add_item(item):
	items.append(item)

func get_items():
	return items

func get_saves():
	var saves = []
	for i in items:
		saves.append(i.save())
	return saves
