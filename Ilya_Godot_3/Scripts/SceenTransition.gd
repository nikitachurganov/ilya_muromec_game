extends Area2D

export(String, FILE, "*.tscn,*.scn") var new_sceen
export var position_x = 0
export var position_y = 0
var stats = PlayerStats

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if get_overlapping_areas().size() > 0:
			next_level()

func next_level():
	stats.position_x = position_x
	stats.position_y = position_y
	var PTS = get_tree().change_scene(new_sceen)
