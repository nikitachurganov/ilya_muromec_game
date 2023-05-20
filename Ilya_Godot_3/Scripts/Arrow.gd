extends Area2D

const speed = 500
var velocity = Vector2.ZERO

func _physics_process(delta):
	velocity.x = speed * delta 
	translate(velocity)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
