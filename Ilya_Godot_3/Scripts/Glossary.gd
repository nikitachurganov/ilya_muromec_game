extends Control


func _ready():
	hide()
	$TextureRect/Control.rect_min_size.x = 130
	$TextureRect/Control.rect_min_size.y = 120
	$TextureRect/Control2.rect_min_size.x = 130
	$TextureRect/Control2.rect_min_size.y = 120
	$TextureRect/ChoosingItem.text = ""
	$TextureRect/Control2/ScrollContainer/VBoxContainer/RichTextLabel.text = ""
	for button in $TextureRect/Control/ScrollContainer/VBoxContainer.get_children():
		button.connect("glossary_button_pressed", self, "_on_glossary_button_pressed")

func _on_glossary_button_pressed(args):
	if len(args) == 2:
		var button_name = args[0]
		var button_text = args[1]
		$TextureRect/ChoosingItem.text = button_name
		$TextureRect/Control2/ScrollContainer/VBoxContainer/RichTextLabel.text = button_text



func _on_TextureButton_pressed():
	$TextureRect/ChoosingItem.text = ""
	$TextureRect/Control2/ScrollContainer/VBoxContainer/RichTextLabel.text = ""
	hide()
