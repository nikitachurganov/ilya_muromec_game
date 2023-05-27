extends TextureButton

export var number = 0

func _on_TextureButton_button_down():
	$TextureRect.rect_position.x += 1
	$TextureRect.rect_position.y += 1
	get_parent().get_parent().get_parent().activeItemChoose(number)
	get_parent().get_parent().get_parent().show_inventory(PlayerStats.inventory)

func _on_TextureButton_button_up():
	$TextureRect.rect_position.x -= 1
	$TextureRect.rect_position.y -= 1


func _on_TextureButton_mouse_entered():
	if !$AudioStreamPlayer.is_playing():
		$AudioStreamPlayer.play()
