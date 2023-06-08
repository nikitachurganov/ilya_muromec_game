extends HSlider

signal slider_value_changed(value)

func _ready():
	# Подписка на глобальный сигнал в обеих сценах
	#get_tree().get_root().connect("slider_value_changed", self, "_on_slider_value_changed")
	connect("slider_value_changed", self, "_on_slider_value_changed")


func _on_MasterSlider_value_changed(value):
	emit_signal("slider_value_changed", value)
	AudioServer.set_bus_volume_db(0, value)

func _on_slider_value_changed(value):
	value = clamp(value, -45, 0)
	set_value(value)
