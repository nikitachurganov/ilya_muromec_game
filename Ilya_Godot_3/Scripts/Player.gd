extends KinematicBody2D


export var AXELERATION = 1000
export var MAX_SPEED = 100
export var ROLL_SPEED = 150
export var FRICTION = 1000
export var EP = true


signal on_death


enum {
	MOVE,
	ROLL,
	ATTACK
}


var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.RIGHT
var stats = PlayerStats
var items = 0
var inventory = []

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var collisionSwordHitbox = $HitboxPivot/SwordHitbox/CollisionShape2D
onready var hurtbox = $Hurtbox
onready var ui = get_viewport().get_node("Root/HealthUI/Control")


func _ready():
	randomize()
	stats.armor = ""
	stats.sword = ""
	stats.helmet = ""
	stats.def = 0
	stats.emit_signal("equipment_changed")
	yield(SceneChanger, "on_game_ready")
	inventory = stats.inventory
	stats.emit_signal("equipment_changed")
	position.x = stats.position_x
	position.y = stats.position_y
	stats.connect("no_health", self, "die")
	animationTree.active = true
	collisionSwordHitbox.disabled = true
	swordHitbox.knockback_vector = roll_vector
	$Timer.start(5)


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
	stats.inventory.push_back(it)
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


func save():
	var data = {
		"filename": get_filename(),
		"position": position,
		"health": stats.health,
		"experience": stats.experience,
		"max_exp": stats.max_exp,
		"max_health": stats.max_health,
		"lvl": stats.lvl,
		"inventory": stats.inventory,
		"sword": stats.sword,
		"helmet": stats.helmet,
		"armor": stats.armor,
		"atk": stats.self_atk
	}
	
	return data


func load_from_data(data):
	position = data["position"]
	stats.health = data["health"]
	stats.experience = data["experience"]
	stats.max_exp = data["max_exp"]
	stats.max_health = data["max_health"]
	stats.atk = data["atk"]
	stats.lvl = data["lvl"]
	stats.inventory = data["inventory"].duplicate(true)
	stats.set_health(stats.health)
	stats.emit_signal("equipment_changed")


func _on_Timer_timeout():
	if EP:
		stats.HP_replenishment(1)
