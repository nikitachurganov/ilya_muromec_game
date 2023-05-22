extends TextureButton

export(String) var label_text = ""

signal glossary_button_pressed(button_name, button_text)

func _ready():
	pass 

func _on_TextureButton_pressed():
	emit_signal("glossary_button_pressed", [$Label.text, label_text])


func _on_TextureButton_button_down():
	$Label.rect_position.x += 1


func _on_TextureButton_button_up():
	$Label.rect_position.x -= 1