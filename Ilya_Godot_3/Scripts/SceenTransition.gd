extends Area2D

export(String, FILE, "*.tscn,*.scn") var new_sceen
export var position_x = 0
export var position_y = 0
var stats = PlayerStats


func next_level():
	stats.position_x = position_x
	stats.position_y = position_y
	var PTS = get_tree().change_scene(new_sceen)


func _on_SceenTransition_body_entered(body):
	next_level()
