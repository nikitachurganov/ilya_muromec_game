extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
const Arrow = preload("res://Effects/Whistle.tscn")
const Destruction = preload("res://Scenes/TreeDestruction.tscn")
const hurtSound = preload("res://Sounds/EnemyDamaged.wav")
const treeHit = preload("res://Sounds/TreeHit.wav")

export var acceleration = 300
export var max_speed = 50
export var friction = 1000
export var GIVE_EXP = 25

enum{
	IDLE,
	IDLE_TREE,
	CHASE,
	ATTACK_HIT, 
	ATTACK_BLOW,
	ATTACK_TREE
}

var velocity =  Vector2.ZERO
var knockback = Vector2.ZERO
var input_vector = Vector2.ZERO
var state = CHASE 
var tree = true


onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var airZone = $AirZoneDetection
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var hurtbox = $Hurtbox
onready var animationState = animationTree.get("parameters/playback")
onready var timer = $AirZoneDetection/Timer
onready var timerHit = $HitZoneDetection/Timer

func _ready():
	state = IDLE_TREE
	
func _process(delta):
	if stats.health >= 125:
		$PlayerDetectionZone/CollisionShape2D.disabled = true
		$HitboxPivot/Hitbox/CollisionShape2D.disabled = true
		$HitZoneDetection/CollisionShape2D.disabled = true
		$Sprite.visible = false
		$SpriteTree.visible = true
		$CollisionShape2D.shape.radius = 5
		$CollisionShape2D.rotation_degrees = 0
		$CollisionShape2D.position.x = -2
		$CollisionShape2D.position.y = -4

	if stats.health < 125 && tree == true:
		tree_destruct()
		tree = false
		$HitboxPivot/Hitbox/CollisionShape2D.disabled = true
		
	
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			seek_player()
		IDLE_TREE:
			animationState.travel("IdleTree")
		CHASE:
			var player = playerDetectionZone.player
			input_vector = input_vector.normalized()
			if player != null:
				input_vector.x = player.global_position.x - global_position.x
				input_vector.y = global_position.y - player.global_position.y
				animationTree.set("parameters/Idle/blend_position", input_vector)
				animationTree.set("parameters/IdleTree/blend_position", input_vector)
				animationTree.set("parameters/Run/blend_position", input_vector)
				animationTree.set("parameters/AttackHit/blend_position", input_vector)
				animationTree.set("parameters/AttackTree/blend_position", input_vector)
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
		ATTACK_TREE:
			attack_tree(delta)
		
	velocity = move_and_slide(velocity)

func tree_destruct():
	var destruction = Destruction.instance()
	get_parent().add_child(destruction)
	destruction.global_position = global_position
	$SpriteTree.visible = false
	var timer = Timer.new()
	timer.wait_time = 2.3
	timer.one_shot = true
	timer.connect("timeout", self, "after_destruct")
	add_child(timer)
	timer.start()
	
func after_destruct():
	$Sprite.visible = true
	$PlayerDetectionZone/CollisionShape2D.disabled = false
	$HitZoneDetection/CollisionShape2D.disabled = false
	$CollisionShape2D.shape.radius = 4
	$CollisionShape2D.rotation_degrees = 90
	$CollisionShape2D.position.x = -1
	$CollisionShape2D.position.y = 12
	state = CHASE

func seek_player():
	if playerDetectionZone.can_see_player() && !tree:
		state = CHASE

func attack_state_blow(delta):
	velocity = Vector2.ZERO
	animationState.travel("AttackBlow")
	
func attack_state_hit(delta):
	velocity = Vector2.ZERO
	animationState.travel("AttackHit")

func attack_tree(delta):
	velocity = Vector2.ZERO
	animationState.travel("AttackTree")

func attack_animation_finished():
	if !tree:
		state = CHASE
	else:
		state = IDLE_TREE

	
func _on_Hurtbox_area_entered(area):
	stats.health -= (PlayerStats.atk + PlayerStats.items[PlayerStats.sword]["attack"])
	
	if !tree:
		$AudioStreamPlayer.stream = hurtSound
		$AudioStreamPlayer.play()
		knockback = area.knockback_vector * 40
	else:
		$AudioStreamPlayer.stream = treeHit
		$AudioStreamPlayer.play()
	hurtbox.create_hit_effect()

func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	PlayerStats.experience += GIVE_EXP

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

func arrow_create():
	var arrow = Arrow.instance()
	var player = airZone.player
	
	if player != null:
		if PlayerStats.health >= 1:
			var player_position = player.global_position
			var direction = (player_position - global_position).normalized()
			arrow.set_direction(direction)
			var input_vector = direction
			input_vector.y *= -1
			get_parent().add_child(arrow)
			arrow.position = $Position2D.global_position
	
func _on_HitZoneDetection_body_entered(body):
	if !tree:
		timerHit.stop()

func _on_AirZoneDetection_body_entered(body):
	if !tree:
		state = ATTACK_BLOW
	else:
		state = ATTACK_TREE
	
	
func _on_AirZoneDetection_body_exited(body):
	if !tree:
		state = IDLE
	else:
		state = IDLE_TREE
	
func _on_Timer_timeout():
	if !tree:
		state = ATTACK_BLOW
	else:
		state = ATTACK_TREE

func _on_HitZoneDetection_body_exited(body):
	if !tree:
		timerHit.stop()

func _on_PlayerDetectionZone_body_entered(body):
	if !tree:
		timer.stop()

func _on_PlayerDetectionZone_body_exited(body):
	if !tree:
		timer.start()

func _on_TimerHit_timeout():
	if !tree:
		state = ATTACK_HIT
