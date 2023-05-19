extends TextureButton

export(String) var scene_to_open


func _on_Button_button_down():
	$Label.rect_position.x += 1
	$Label.rect_position.y += 1


func _on_Button_button_up():
	$Label.rect_position.x -= 1
	$Label.rect_position.y -= 1
