extends Node

export var max_health = 1 setget set_max_health
var health = max_health setget set_health
export var atk = 10 setget set_atk
export var max_exp = 500 setget set_max_exp
export var experience = 0 setget set_exp
onready var lvl = 1 setget set_lvl
export var def = 0 
export var position_x = 150
export var position_y = 150
var inventory = []
var sword = ""
var helmet = ""
var armor = ""

var items = {
	"": {"attack": 0, "def": 0},
	"Helmet1": {"def": 2, "type": "helmet", "name": "Кожаный шлем"},
	"Helmet2": {"def": 5, "type": "helmet", "name": "Простой шлем"},
	"Helmet3": {"def": 10, "type": "helmet", "name": "Металлический шлем"},
	"Sword1": {"attack": 2, "type": "sword", "name": "Простой меч"},
	"Sword2": {"attack": 5, "type": "sword", "name": "Железный меч"},
	"Sword3": {"attack": 10, "type": "sword", "name": "Меч Кладенец"},
	"Armor1": {"def": 2, "type": "armor", "name": "Кожаная броня"},
	"Armor2": {"def": 5, "type": "armor", "name": "Кольчуга"},
	"Armor3": {"def": 10, "type": "armor", "name": "Доспехи"},
	"Milk": {"heal": 5, "type": "food", "name": "Молоко"},
	"Apple": {"heal": 2, "type": "food", "name": "Яблоко"},
	"Pie": {"heal": 3, "type": "food", "name": "Пирожок"}
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
			set_atk(atk)
		else:
			inventory.push_back(sword)
			sword = equipment
			set_atk(atk)
	
	if equipment == "Armor1" or equipment == "Armor2" or equipment == "Armor3":
		if armor == "":
			armor = equipment
			set_def()
		else:
			inventory.push_back(armor)
			armor = equipment
			set_def()
	
	if equipment == "Helmet1" or equipment == "Helmet2" or equipment == "Helmet3":
		if helmet == "":
			helmet = equipment
			set_def()
		else:
			inventory.push_back(helmet)
			helmet = equipment
			set_def()
	
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

func set_def():
	def = items[armor]["def"] + items[helmet]["def"]
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
	set_atk(atk)
