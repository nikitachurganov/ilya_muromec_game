extends Area2D

signal talk

func _input(event):
	if event.is_action_pressed("ui_accept") and len(get_overlapping_bodies()) > 0:
		use_dialogue()
		if PlayerStats.quests[0] == "Поговорить с родителями" or PlayerStats.quests[0] == "Поговорить с Князем" or PlayerStats.quests[0] == "Поговорить с детьми Соловья" or PlayerStats.quests[0] == "Поговорить со стражниками":
			PlayerStats.quests.pop_front()
			emit_signal("talk")

func use_dialogue():
	var dialogue = get_parent().get_node("CanvasLayer")
	
	if dialogue:
		dialogue.start()
