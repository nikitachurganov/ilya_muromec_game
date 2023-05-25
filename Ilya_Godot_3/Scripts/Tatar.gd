extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export var acceleration = 300
export var max_speed = 50
export var friction = 1000
export var WANDER_TARGET_RANGE = 4

enum{
	IDLE,
	CHASE,
	ATTACK,
	WANDER
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
onready var timer = $HitZoneDetection/Timer
onready var wanderController = $WanderController
onready var healthBar = $HealthBar/Control/TextureRect
onready var animationState = animationTree.get("parameters/playback")

var max_health = 100
var currentHealth = max_health
var direction


func _ready():
	$HitboxPivot/Hitbox/CollisionShape2D.disabled = true
	state = pick_random_state([IDLE, WANDER])
	healthBar.rect_size.x = 28
	healthBar.rect_min_size.y = 3
	

func _physics_process(delta):
	if wanderController.start_position == Vector2.ZERO:
		wanderController.start_position = global_position
	
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)
	
	
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
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
				direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
				
			else:
				animationState.travel("Idle")
				state = IDLE
		ATTACK:
			attack_state(delta)
			
		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
			accelerate_towards_point(wanderController.target_position, delta)
			if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
				update_wander()
				
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
	currentHealth = clamp(stats.health, 0, max_health)
	healthBar.rect_size.x = (currentHealth * 28 / max_health)
	knockback = area.knockback_vector * 40
	hurtbox.create_hit_effect()

func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * max_speed, acceleration * delta)

func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1, 3))

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

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

func _on_HitZoneDetection_body_entered(body):
	timer.start()


func _on_HitZoneDetection_body_exited(body):
	timer.stop()

	
func _on_Timer_timeout():
	state = ATTACK
