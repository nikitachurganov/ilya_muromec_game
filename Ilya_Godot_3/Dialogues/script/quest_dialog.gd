extends Area2D

signal talk

export var quest = ""

func _input(event):
	if event.is_action_pressed("ui_accept") and len(get_overlapping_areas()) > 0:
		use_dialogue()
		if PlayerStats.quests[0] == quest:
			PlayerStats.quests.pop_front()
			emit_signal("talk")

func use_dialogue():
	var dialogue = get_parent().get_node("CanvasLayer")
	
	if dialogue:
		dialogue.start()
