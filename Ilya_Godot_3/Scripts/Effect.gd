extends AnimatedSprite

onready var sound = $AudioStreamPlayer

func _ready():
	self.connect("animation_finished", self, "_on_animation_finished")
	sound.play()
	play("Animate")
	

func _on_animation_finished():
	queue_free()
