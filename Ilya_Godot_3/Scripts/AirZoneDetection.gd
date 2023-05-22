extends Area2D

var invincible = false setget set_invincible

onready var timer = $Timer
onready var collisionShape = $CollisionShape2D

signal invincibility_started
signal invincibility_ended

func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")


func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func _on_Timer_timeout():
	self.invincible = false


func _on_HitZoneDetectionAir_invincibility_ended():
	collisionShape.disabled = false


func _on_HitZoneDetectionAir_invincibility_started():
	collisionShape.set_deferred("disabled", true)


var player = null

func can_see_player():
	return player != null


func _on_AirZoneDetection_body_entered(body):
	player = body

