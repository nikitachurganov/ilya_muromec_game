extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
const Arrow = preload("res://Scenes/Arrow.tscn")

export var acceleration = 300
export var max_speed = 50
export var friction = 1000

enum{
	IDLE,
	CHASE,
	ATTACK_HIT, 
	ATTACK_BLOW
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
				animationTree.set("parameters/AttackHit/blend_position", input_vector)
				animationTree.set("parameters/AttackBlow/blend_position", input_vector)
				animationState.travel("Run")
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
				
			else:
				animationState.travel("Idle")
				state = IDLE
		ATTACK_HIT:
			attack_state_hit(delta)
		ATTACK_BLOW:
			attack_state_blow(delta)
			
	velocity = move_and_slide(velocity)

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func attack_state_blow(delta):
	velocity = Vector2.ZERO
	var arrow = Arrow.instance()
	
	get_parent().add_child(arrow)
	arrow.position = $Position2D.global_position
	state = CHASE
	animationState.travel("AttackBlow")
	

func attack_state_hit(delta):
	animationState.travel("AttackHit")
	
	

func attack_animation_finished():
	state = CHASE
	

func _on_Hurtbox_area_entered(area):
	stats.health -= (PlayerStats.atk + PlayerStats.items[PlayerStats.sword]["attack"])
	knockback = area.knockback_vector * 40
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
	state = ATTACK_HIT

func _on_HitZoneDetectionAir_area_entered(area):
	state = ATTACK_BLOW
