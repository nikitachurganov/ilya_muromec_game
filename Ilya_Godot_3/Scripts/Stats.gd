extends Node

export var max_health = 1 setget set_max_health
var health = max_health setget set_health
export var atk = 10 setget set_atk
export var max_exp = 500 setget set_max_exp
export var experience = 0 setget set_exp
onready var lvl = 1 setget set_lvl
export var def = 0 setget set_def
export var position_x = 150
export var position_y = 150
var inventory = []
var items

onready var save_dir = "user://Saves"
onready var save_temp = "%s.tres"

signal no_health
signal lvl_up
signal health_change(value)
signal max_health_changed(value)
signal atk_changed(value)
signal exp_changed(value)
signal max_exp_changed(value)
signal lvl_changed(value)
signal def_changed(value)

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)

func set_atk(value):
	atk = value
	emit_signal("atk_changed", atk)

func set_max_exp(value):
	max_exp = value
	emit_signal("max_exp_changed", max_exp)

func set_def(value):
	def = value
	emit_signal("def_changed", def)

func set_exp(value):
	experience = value
	emit_signal("exp_changed", experience)
	if experience >= max_exp:
		lvl += 1
		experience = experience - max_exp
		set_max_exp(max_exp + 50)
		set_exp(experience)
		set_atk(atk + 5)
		set_max_health(max_health + 10)
		set_health(max_health)
		set_def(def + 10)
		set_lvl(lvl)

func set_lvl(value):
	lvl = value
	emit_signal("lvl_changed", lvl)

func set_health(value):
	health = value
	emit_signal("health_change", health)
	if health <= 0:
		emit_signal("no_health")

func _ready():
	self.health = max_health
