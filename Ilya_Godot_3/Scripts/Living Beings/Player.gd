extends "res://Stats/KinematicBody2D.gd"


export var ROLL_SPEED = 150


var inventory = []
var stats = PlayerStats
var roll_vector = Vector2.RIGHT
var state = MOVE


onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var collisionSwordHitbox = $HitboxPivot/SwordHitbox/CollisionShape2D
onready var hurtbox = $Hurtbox
onready var ui = get_viewport().get_node("Root/HealthUI/Control")


enum {
	MOVE,
	ROLL,
	ATTACK
}


func _ready():
	randomize()
	inventory = stats.inventory
	position.x = stats.position_x
	position.y = stats.position_y
	stats.connect("no_health", self, "die")
	animationTree.active = true
	collisionSwordHitbox.disabled = true
	swordHitbox.knockback_vector = roll_vector


func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
			
		ROLL:
			roll_state(delta)
		
		ATTACK:
			attack_state(delta)


func pick(item):
	var it = item.get_item()
	#inventory.push_back(it)
	stats.inventory.push_back(it)
	print(inventory.size())
	ui.update_inventory(inventory)


func _unhandled_input(event):
	if event.is_action_pressed("inventory"):
		ui.toggle_inventory(inventory)


func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Move/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Move")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, AXELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move()
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	if Input.is_action_just_pressed("attack"):
		state = ATTACK


func roll_state(delta):
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()


func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")


func move():
	velocity = move_and_slide(velocity)


func roll_animation_finished():
	velocity = velocity * 0.8
	state = MOVE


func attack_animation_finished():
	state = MOVE


func _on_Hurtbox_area_entered(area):
	stats.health -= (area.damage - (stepify(float(area.damage) / 100 * stats.def, 1)))
	hurtbox.start_invincibility(0.5)
	hurtbox.create_hit_effect()


func die():
	emit_signal("on_death")
	queue_free()
