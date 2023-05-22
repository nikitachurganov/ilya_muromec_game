extends Area2D

onready var timer = $Timer
onready var collisionShape = $CollisionShape2D

var player = null
var state = "ATTACK_HIT"

func can_see_player():
	return player != null

func _on_HitZoneDetection_body_entered(body):
	player = body


func _on_HitZoneDetection_body_exited(body):
	player = null

	
