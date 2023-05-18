extends Control



func _ready():
	hide()
	for button in get_node("HBoxContainer/Control2/ScrollContainer/VBoxContainer").get_children():
		button.connect("button_glossariy_pressed", self, "_on_button_glossariy_pressed")
	
	$HBoxContainer/Control/ScrollContainer.visible = false

func open():
	if visible:
		hide()
	else:
		show()

func _on_button_glossariy_pressed(arg1, arg2):
	$Label2.text = arg1
	$HBoxContainer/Control/ScrollContainer/VBoxContainer/RichTextLabel.text = arg2
	$HBoxContainer/Control/ScrollContainer.visible = true
	$HBoxContainer/Control.rect_position.x = 147
	$HBoxContainer/Control/ScrollContainer.rect_min_size.x = 139


func _on_TextureButton_pressed():
	$Label2.text = ""
	$HBoxContainer/Control/ScrollContainer.visible = false
	open()
