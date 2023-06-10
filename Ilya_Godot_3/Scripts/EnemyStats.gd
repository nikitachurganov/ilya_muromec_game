extends Node

export var max_health = 1 setget set_max_health
var health = max_health setget set_health
#export var position_x = 150
#export var position_y = 150
var soundEffect = true

onready var saving_group = "TO_BE_SAVED"
onready var save_dir = "user://Saves"
onready var save_temp = "%s.tres"

signal no_health
signal health_change(value)
signal max_health_changed(value)

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)

func set_health(value):
	health = value
	emit_signal("health_change", health)
	if health <= 0:
		emit_signal("no_health")

func _ready():
	self.health = max_health
