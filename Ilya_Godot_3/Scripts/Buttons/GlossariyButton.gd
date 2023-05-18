extends TextureButton

export(String) var label_text = ""

signal button_glossariy_pressed(text, label_text)

func _on_TextureButton_button_down():
	$Label.rect_position.x += 1
	$Label.rect_position.y += 1


func _on_TextureButton_button_up():
	$Label.rect_position.x -= 1
	$Label.rect_position.y -= 1


func _on_TextureButton_pressed():
	emit_signal("button_glossariy_pressed", $Label.text, label_text)
