extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export var acceleration = 300
export var max_speed = 30
export var friction = 1000

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
onready var  animationTree = $AnimationTree
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
				animationTree.set("parameters/Attack/blend_position", input_vector)
				
				animationState.travel("Run")
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
				
				
				if  (player.global_position.x - global_position.x <=  1 && player.global_position.x - global_position.x >=  -1) ||(player.global_position.y - global_position.y <=  1 && player.global_position.y - global_position.y >=  -1) :
					print(player.global_position - global_position)
					state = ATTACK
					
				
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
	
	stats.health -= PlayerStats.atk
	knockback = area.knockback_vector * 40
	hurtbox.create_hit_effect()

func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position

func _on_Hitbox_body_entered(body):
	pass

func _on_Hitbox_area_entered(area):
	pass
	
