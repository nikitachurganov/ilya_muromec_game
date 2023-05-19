extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export var acceleration = 150
export var max_speed = 20
export var friction = 200

enum{
	IDLE,
	CHASE,
	ATTACK
}

var velocity =  Vector2.ZERO
var knockback = Vector2.ZERO
var input_vector = Vector2.ZERO

var state = CHASE 

onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var hurtbox = $Hurtbox
onready var hitzone = $HitZone
onready var animationState = animationTree.get("parameters/playback")

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			seek_player()
		CHASE:
			var player = playerDetectionZone.player
			input_vector = input_vector.normalized()
			if player != null:
				input_vector.x = player.global_position.x - global_position.x
				input_vector.y = global_position.y - player.global_position.y
				animationTree.set("parameters/Idle/blend_position", input_vector)
				animationTree.set("parameters/Run/blend_position", input_vector)
				animationTree.set("parameters/Attack/blend_position", input_vector)
				
				animationState.travel("Run")
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
				
			else:
				animationState.travel("Idle")
				state = IDLE
		ATTACK:
			attack_state(delta)
			
	velocity = move_and_slide(velocity)

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
	
func attack_animation_finished():
	state = CHASE
	

func _on_Hurtbox_area_entered(area):
	stats.health -= (PlayerStats.atk + PlayerStats.items[PlayerStats.sword]["attack"])
	knockback = area.knockback_vector * 70
	hurtbox.create_hit_effect()

func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position


func save():
	var data = {
		"filename": get_filename(),
		"position": position,
		"health": stats.health,
		"max_health": stats.max_health,
		"state": state,
		"global_position": global_position
	}
	
	return data


func load_from_data(data):
	position = data["position"]
	global_position = data["global_position"]
	stats.health = data["health"]
	stats.max_health = data["max_health"]
	state = data["state"]
	stats.set_health(stats.health)

func _on_HitZoneDetection_area_entered(area):
	state = ATTACK
