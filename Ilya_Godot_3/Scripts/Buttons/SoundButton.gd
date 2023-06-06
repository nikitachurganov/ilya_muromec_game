extends TextureButton

signal soundToggled(value)

func _on_Button_pressed():
	toggleSound()

func toggleSound():
	var audioServer = AudioServer.get_singleton()
	var muted = !audioServer.bus_is_mute(AudioServer.BUS_ALL)
	
	# Отправляем сигнал soundToggled всем подписчикам
	emit_signal("soundToggled", muted)
	
	# Переключаем звук включен/выключен
	audioServer.bus_set_mute(AudioServer.BUS_ALL, !muted)
