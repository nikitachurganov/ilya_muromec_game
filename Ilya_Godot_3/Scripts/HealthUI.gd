extends Control

var health = 100 setget set_health
var max_health = 100 setget set_max_health
var atk = 10 setget set_atk
var experience = 0 setget set_exp
var max_exp = 500 setget set_max_exp
var lvl = 1 setget set_lvl
var def = 0 setget set_def

func set_health(value):
	var labelHealth = $LabelHealth
	var healthUIFull = $TextureHealth
	health = clamp(value, 0, max_health)
	if labelHealth != null:
		labelHealth.text = str(health) + " HP"
	if healthUIFull != null:
		healthUIFull.rect_size.x = health / max_health * 64

func set_atk(value):
	var labelAtk = $LabelAtk
	atk = clamp(value, 0, 100)
	if labelAtk != null:
		labelAtk.text = str(atk)

func set_def(value):
	var labelDef = $LabelDef
	def = clamp(value, 0, 100)
	if labelDef != null:
		labelDef.text = str(def)

func set_exp(value):
	var labelExp = $LabelExp
	experience = clamp(value, 0, max_exp)
	if labelExp != null:
		labelExp.text = "EXP = " + str(experience) + "/" + str(max_exp)

func set_lvl(value):
	var labelLvl = $LabelLvl
	lvl = clamp(value, 0, 500)
	if labelLvl != null:
		labelLvl.text = "LVL " + str(lvl)

func set_max_health(value):
	max_health = max(value, 1)
	self.health = min(health, max_health)

func set_max_exp(value):
	max_exp = max(value, 1)

func _ready():
	self.max_health = PlayerStats.max_health
	self.health = PlayerStats.health
	self.atk = PlayerStats.atk
	self.def = PlayerStats.def
	self.experience = PlayerStats.experience
	self.lvl = PlayerStats.lvl
	self.max_exp = PlayerStats.max_exp
	set_health(health)
	set_atk(atk)
	set_def(def)
	set_exp(experience)
	set_lvl(lvl)
	PlayerStats.connect("health_change", self, "set_health")
	PlayerStats.connect("max_health_changed", self, "set_max_health")
	PlayerStats.connect("atk_changed", self, "set_atk")
	PlayerStats.connect("lvl_changed", self, "set_lvl")
	PlayerStats.connect("def_changed", self, "set_def")
	PlayerStats.connect("max_exp_changed", self, "set_max_exp")
	PlayerStats.connect("exp_changed", self, "set_exp")
