extends Area2D

onready var collisionShape = $CollisionShape2D
onready var timer = $Timer

var player = null

func can_see_player():
	return player != null

func _on_AirZoneDetection_body_entered(body):
	player = body
	timer.start()
	
func _on_AirZoneDetection_body_exited(body):
	player = null
	timer.stop()
