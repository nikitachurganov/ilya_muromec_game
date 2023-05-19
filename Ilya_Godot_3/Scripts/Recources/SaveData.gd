extends Resource

export var save_name = "" setget set_name
export var data = {} setget set_data, get_data

func get_saved_name():
	return "save"

func set_name(n):
	save_name = n

func set_data(d):
	data = d.duplicate(true)

func get_data():
	return data
