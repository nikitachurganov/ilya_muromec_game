extends Area2D

export var damage = 1
const speed = 200
var velocity = Vector2.ZERO


func _physics_process(delta):
	translate(velocity * delta)

func set_direction(direction: Vector2):
	velocity = direction * speed

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Arrow_area_entered(area):
	queue_free()
