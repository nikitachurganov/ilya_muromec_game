extends TextureButton

var soundOffDef = load("res://Art/Buttons/SoundOffDefault.png")
var soundOnDef = load("res://Art/Buttons/SoundOnDefault.png")

var soundOffHov = load("res://Art/Buttons/SoundOffHover.png")
var soundOnHov = load("res://Art/Buttons/SoundOnHover.png")

var soundOffPress = load("res://Art/Buttons/SoundOffPressed.png")
var soundOnPress = load("res://Art/Buttons/SoundOnPressed.png")

var stats = PlayerStats




func _on_TextureButton_pressed():
	if stats.soundEffect:
		self.texture_normal  = soundOffDef
		self.texture_hover  = soundOffHov
		self.texture_pressed  = soundOffPress
		stats.soundEffect = false
		
		AudioServer.set_bus_volume_db(0, -200)
	else:
		self.texture_normal = soundOnDef
		self.texture_hover  = soundOnHov
		self.texture_pressed  = soundOnPress
		stats.soundEffect = true
		AudioServer.set_bus_volume_db(0, -4)

func _on_TextureButton_button_down():
	if !$AudioStreamPlayer.is_playing():
		$AudioStreamPlayer.play()


func _on_TextureButton_mouse_entered():
	$AudioStreamPlayer.play()
