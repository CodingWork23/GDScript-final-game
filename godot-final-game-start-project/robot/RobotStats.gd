class_name RobotStats
extends Resource

enum SpellType {FIRE, ICE, LIGHT}
enum Emblems {NONE, ROBOT, SWORD, MACE, HAMMER}

# Health
export var max_health := 12 setget set_max_health
export var health : int = 12 setget set_health
# HealKits
export var max_heal_kit := 2 setget set_max_heal_kit
export var heal_power := 6 setget set_heal_power
export var heal_kit := 1 setget set_heal_kit
# SpellHolder
export(int, 0, 3) var fire_index := 1 setget set_fire_index
export(int, 0, 3) var ice_index := 0 setget set_ice_index
export(int, 0, 4) var light_index := 0 setget set_light_index
export(SpellType) var current_type := 0 setget set_current_type
# Spellfragments
export var fire_fragment := 0 setget set_fire_fragment
export var max_fire_fragment := 3 setget set_max_fire_fragment
export var ice_fragment := 0 setget set_ice_fragment
export var max_ice_fragment := 2 setget set_max_ice_fragment
export var light_fragment := 0 setget set_light_fragment
export var max_light_fragment := 2 setget set_max_light_fragment
# Gems
export(int, 0, 9999) var gold_gems := 0 setget set_gold_gems
# Emblem
export(Emblems) var current_emblem := Emblems.NONE setget set_current_emblem


# RESET STATS
# Health
var _max_health : int = max_health
var _health : int = health
# HealKits
var _max_heal_kit : int = max_heal_kit
var _heal_power : int = heal_power
var _heal_kit : int = heal_kit
# SpellHolder
var _fire_index : int = fire_index
var _ice_index : int = ice_index
var _light_index : int = light_index
var _current_type : int = current_type
# Spellfragments
var _fire_fragment := fire_fragment
var _max_fire_fragment := max_fire_fragment
var _ice_fragment := ice_fragment
var _max_ice_fragment := max_ice_fragment
var _light_fragment := light_fragment
var _max_light_fragment := max_light_fragment
#Gems
var _gold_gems : int = gold_gems
# Emblem
var _current_emblem := current_emblem


func save() -> void:
	ResourceSaver.save(resource_path, self)

func reset_stats() -> void:
	max_health = _max_health
	health = _health
	# HealKits
	max_heal_kit = _max_heal_kit
	heal_power = _heal_power
	heal_kit = _heal_kit
	# SpellHolder
	fire_index = _fire_index
	ice_index = _ice_index
	light_index = _light_index
	current_type = _current_type
	# Spellfragments
	fire_fragment = _fire_fragment
	max_fire_fragment = _max_fire_fragment
	ice_fragment = _ice_fragment
	max_ice_fragment = _max_ice_fragment
	light_fragment = _light_fragment
	max_light_fragment = _max_light_fragment
	# Gems
	gold_gems = _gold_gems
	# Emblem
	current_emblem = _current_emblem
	save()

# Health
func set_max_health(new_value: int) -> void:
	max_health = new_value
	save()

func set_health(new_value: int) -> void:
	health = clamp(new_value, 0, max_health)
	save()

# HealKits
func set_max_heal_kit(new_value: int) -> void:
	max_heal_kit = new_value
	save()

func set_heal_power(new_value: int) -> void:
	heal_power = new_value
	save()

func set_heal_kit(new_value: int) -> void:
	heal_kit = clamp(new_value, 0, max_heal_kit)
	save()

# SpellHolder
func set_fire_index(new_value: int) -> void:
	fire_index = new_value
	save()

func set_ice_index(new_value: int) -> void:
	ice_index = new_value
	save()

func set_light_index(new_value: int) -> void:
	light_index = new_value
	save()

func set_current_type(new_value: int) -> void:
	current_type = new_value
	save()

# Spellfragments
func set_fire_fragment(new_value: int) -> void:
	fire_fragment = new_value
	save()
func set_max_fire_fragment(new_value: int) -> void:
	max_fire_fragment = new_value
	save()

func set_ice_fragment(new_value: int) -> void:
	ice_fragment = new_value
	save()
func set_max_ice_fragment(new_value: int) -> void:
	max_ice_fragment = new_value
	save()

func set_light_fragment(new_value: int) -> void:
	light_fragment = new_value
	save()
func set_max_light_fragment(new_value: int) -> void:
	max_light_fragment = new_value
	save()

# Gems
func set_gold_gems(new_value: int) -> void:
	gold_gems = clamp(new_value, 0, 9999)
	save()

# Emblem
func set_current_emblem(new_value: int) -> void:
	current_emblem = new_value
	save()
