extends Area2D

export var damage = 10
const speed = 70
var velocity = Vector2.ZERO
var offset = 0.05

func _physics_process(delta):
	translate(velocity * delta)

func set_direction(direction: Vector2):
	
	rotation = direction.angle()
	direction.y -= offset
	velocity = direction * speed 

func _on_Whistle_area_entered(area):
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
