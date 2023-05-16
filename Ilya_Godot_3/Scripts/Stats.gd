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
var self_atk = atk
var items
var sword = ""
var helmet = ""
var armor = ""

var swords = {
	"Sword1": {"attack": 2},
	"Sword2": {"attack": 5},
	"Sword3": {"attack": 10}
}
var armors = {
	"Armor1": {"def": 2},
	"Armor2": {"def": 5},
	"Armor3": {"def": 10}
}
var helmets = {
	"Helmet1": {"def": 2},
	"Helmet2": {"def": 5},
	"Helmet3": {"def": 10}
}

onready var saving_group = "TO_BE_SAVED"
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
signal equipment_changed

func set_equipment(equipment):
	if equipment == "":
		return
	
	if equipment == "Sword1" or equipment == "Sword2" or equipment == "Sword3":
		if sword == "":
			sword = equipment
			set_atk(atk + swords[equipment]["attack"])
		else:
			inventory.push_back(sword)
			set_atk(atk - swords[sword]["attack"])
			sword = equipment
			set_atk(atk + swords[equipment]["attack"])
	
	if equipment == "Armor1" or equipment == "Armor2" or equipment == "Armor3":
		if armor == "":
			armor = equipment
			set_def(def + armors[equipment]["def"])
		else:
			inventory.push_back(armor)
			set_def(def - armors[armor]["def"])
			armor = equipment
			set_def(def + armors[armor]["def"])
	
	if equipment == "Helmet1" or equipment == "Helmet2" or equipment == "Helmet3":
		if helmet == "":
			helmet = equipment
			set_def(def + helmets[equipment]["def"])
		else:
			inventory.push_back(helmet)
			set_def(def - helmets[helmet]["def"])
			helmet = equipment
			set_def(def + helmets[helmet]["def"])
	
	emit_signal("equipment_changed")

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

func HP_replenishment(val):
	self.health = min(self.health + val, self.max_health)

func set_exp(value):
	experience = value
	emit_signal("exp_changed", experience)
	if experience >= max_exp:
		lvl += 1
		experience = experience - max_exp
		set_max_exp(max_exp + 50)
		set_exp(experience)
		set_atk(atk + 5)
		self_atk = atk
		set_max_health(max_health + 10)
		set_health(max_health)
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
