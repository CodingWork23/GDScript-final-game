# This is a simple node. All it does is:
#
# 1. Look at the mouse.
# 2. Set a weapon (spell) as a child.
#
# Since it's an Area2D, it is detected by pickups, which can use it to change
# the currently selected spell.
#
# This script only takes care of rotating towards the mouse and holding a spell.
#
# What happens when the player presses "fire" is entirely up to the spell. And
# what happens when the SpellHolder goes over a pickup is entirely up to the
# pickup.
class_name SpellHolder
extends Area2D

export var robot_stats : Resource = null

enum Type {FIRE, ICE, LIGHT}

const fire_spell := {
	0 : null,
	1 : preload("res://spells/fire_basic/SpellBasicFire.tscn"),
	2 : preload("res://spells/fire_spray/FireSpraySpell.tscn"),
	3 : preload("res://spells/fire_spike/FireSpikeSpell.tscn")
	
}

const ice_spell := {
	0 : null,
	1 : preload("res://spells/ice_punch/IceBasicSpell.tscn"),
	2 : preload("res://spells/ice_punch/SuperIceSpell.tscn"),
	3 : preload("res://spells/ice_cannon/IceCannon.tscn")
}

const light_spell := {
	0 : null,
	1 : preload("res://spells/lightning_shot/LightningSpell.tscn"),
	2 : preload("res://spells/loaded_shoot/LoadedShoot.tscn"),
	3 : preload("res://spells/light_dart_shooter/DartShooter.tscn")
}

export(int, 0, 3) var fire_index := 1 setget set_fire_index
export(int, 0, 3) var ice_index := 0 setget set_ice_index
export(int, 0, 3) var light_index := 0 setget set_light_index

onready var max_fire_fragment := fire_index + 1 setget set_max_fire_fragment
onready var max_ice_fragment := ice_index + 1 setget set_max_ice_fragment
onready var max_light_fragment := light_index + 1 setget set_max_light_fragment

var fire_fragment := 0 setget set_fire_fragment
var ice_fragment := 0 setget set_ice_fragment
var light_fragment := 0 setget set_light_fragment


onready var spell_type := {
	#"" : null,
	"fire" : fire_spell[fire_index],
	"ice" : ice_spell[ice_index],
	"light" : light_spell[light_index]
}

onready var spell_index := {
	#"" : null,
	"fire" : fire_index,
	"ice" : ice_index,
	"light" : light_index
}

onready var current_spell := {
	Type.FIRE : "fire",
	Type.ICE : "ice",
	Type.LIGHT : "light"
}

onready var select_audios := {
	Type.FIRE : $SelectFireAudio,
	Type.ICE : $SelectIceAudio,
	Type.LIGHT : $SelectLightAudio
}

export(Type) var current_type

var spell_scene: PackedScene# setget set_spell_scene

# This is the unique child of the node. It only accepts a spell
var spell: Spell

onready var _spell_spawning_point := $SpellSpawningPoint


func _ready() -> void:
	if not robot_stats:
		set_fire_index(fire_index)
		set_ice_index(ice_index)
		set_light_index(light_index)
	else:
		set_fire_index(robot_stats.fire_index)
		set_ice_index(robot_stats.ice_index)
		set_light_index(robot_stats.light_index)
		current_type = robot_stats.current_type
		set_max_fire_fragment(robot_stats.max_fire_fragment)
		set_max_ice_fragment(robot_stats.max_ice_fragment)
		set_max_light_fragment(robot_stats.max_light_fragment)
		set_fire_fragment(robot_stats.fire_fragment)
		set_ice_fragment(robot_stats.ice_fragment)
		set_light_fragment(robot_stats.light_fragment)
		
		
		spell_type = {
			"fire" : fire_spell[fire_index],
			"ice" : ice_spell[ice_index],
			"light" : light_spell[light_index]
		}
		spell_index = {
			"fire" : fire_index,
			"ice" : ice_index,
			"light" : light_index
		}
	
	Events.emit_signal("update_max_spell_bar", 0, max_fire_fragment)
	Events.emit_signal("update_max_spell_bar", 1, max_ice_fragment)
	Events.emit_signal("update_max_spell_bar", 2, max_light_fragment)
	
	set_spell_scene(current_spell[current_type])

func _physics_process(_delta: float):
	# This function makes the node rotate towards the mouse
	look_at(get_global_mouse_position())

func set_fire_index(new_fire_index: int) -> void:
	fire_index = clamp(new_fire_index, 0, fire_spell.size() - 1)
	robot_stats.fire_index = fire_index

func set_ice_index(new_ice_index: int) -> void:
	ice_index = clamp(new_ice_index, 0, ice_spell.size() - 1)
	robot_stats.ice_index = ice_index

func set_light_index(new_light_index: int) -> void:
	light_index = clamp(new_light_index, 0, light_spell.size() - 1)
	robot_stats.light_index = light_index

func set_fire_fragment(new_fire_fragment: int) -> void:
	fire_fragment = new_fire_fragment
	if fire_fragment >= max_fire_fragment:
		fire_fragment = 0
		level_up_spell("fire")
		set_max_fire_fragment(max_fire_fragment + 1)
	Events.emit_signal("update_spell_bar", 0, fire_fragment)
	if robot_stats:
		robot_stats.fire_fragment = fire_fragment
		robot_stats.max_fire_fragment = max_fire_fragment

func set_ice_fragment(new_ice_fragment: int) -> void:
	ice_fragment = new_ice_fragment
	if ice_fragment >= max_ice_fragment:
		ice_fragment = 0
		level_up_spell("ice")
		set_max_ice_fragment(max_ice_fragment + 1)
	Events.emit_signal("update_spell_bar", 1, ice_fragment)
	if robot_stats:
		robot_stats.ice_fragment = ice_fragment
		robot_stats.max_ice_fragment = max_ice_fragment

func set_light_fragment(new_light_fragment: int) -> void:
	light_fragment = new_light_fragment
	if light_fragment >= max_light_fragment:
		light_fragment = 0
		level_up_spell("light")
		set_max_light_fragment(max_light_fragment + 1)
	Events.emit_signal("update_spell_bar", 2, light_fragment)
	if robot_stats:
		robot_stats.light_fragment = light_fragment
		robot_stats.max_light_fragment = max_light_fragment

func set_max_fire_fragment(new_value: int) -> void:
	max_fire_fragment = clamp(new_value, 0, fire_spell.size() + 1)
	Events.emit_signal("update_max_spell_bar", 0, max_fire_fragment)
	
func set_max_ice_fragment(new_value: int) -> void:
	max_ice_fragment = clamp(new_value, 0, ice_spell.size() + 1)
	Events.emit_signal("update_max_spell_bar", 1, max_ice_fragment)
	
func set_max_light_fragment(new_value: int) -> void:
	max_light_fragment = clamp(new_value, 0, light_spell.size() + 1)
	Events.emit_signal("update_max_spell_bar", 2, max_light_fragment)

func increase_spell_fragment(spell_type_name: String) -> void:
	if spell_type_name == "fire":
		set_fire_fragment(fire_fragment + 1)
	elif spell_type_name == "ice":
		set_ice_fragment(ice_fragment + 1)
	elif spell_type_name == "light":
		set_light_fragment(light_fragment + 1)

func level_up_spell(spell_type_name: String) -> void:
	if spell_type_name == "fire":
		set_fire_index(fire_index + 1)
		spell_type[spell_type_name] = fire_spell[fire_index]
		spell_index["fire"] = fire_index
		set_spell_scene("fire")
		if robot_stats:
			robot_stats.fire_index = fire_index
	elif spell_type_name == "ice":
		set_ice_index(ice_index + 1)
		spell_type[spell_type_name] = ice_spell[ice_index]
		spell_index["ice"] = ice_index
		set_spell_scene("ice")
		if robot_stats:
			robot_stats.ice_index = ice_index
	elif spell_type_name == "light":
		set_light_index(light_index + 1)
		spell_type[spell_type_name] = light_spell[light_index]
		spell_index["light"] = light_index
		set_spell_scene("light")
		if robot_stats:
			robot_stats.ice_index = ice_index

# This function takes care of replacing the current spell instance with a new
# one.
func set_spell_scene(spell_type_name: String) -> void:
	#level_up_spell(spell_type_name)
	spell_scene = spell_type[spell_type_name]
	if spell:
		spell.queue_free()

	# If the node hasn't been added to the scene tree yet, pause the function until it emits its "ready" signal.
	# This is necessary if you assign a spell scene in the Inspector, as Godot will try to run this function right after creating this node in memory, before adding it to the scene tree.
	if not is_inside_tree():
		yield(self, "ready")

	if spell_scene:
		var new_spell = spell_type[spell_type_name].instance()
		assert(new_spell is Spell, "You passed a scene that is not a Spell to the SpellHolder.")

		spell = new_spell
		_spell_spawning_point.add_child(spell)
		spell._cooldown_timer.start()
		
		Events.emit_signal("selected_spell_changed", spell_type[spell_type_name])
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("cycle_weapon_up"):
		var new_current_type : int = current_type + 1
		if new_current_type > Type.size() - 1:
			new_current_type = 0
		equip_spell_type(new_current_type)
	if event.is_action_pressed("cycle_weapon_down"):
		var new_current_type : int = current_type - 1
		if new_current_type < 0:
			new_current_type = Type.size() - 1
		equip_spell_type(new_current_type)
	
	if event.is_action_pressed("equip_fire"):
		var new_current_type : int = Type.FIRE
		equip_spell_type(new_current_type)
	if event.is_action_pressed("equip_ice"):
		var new_current_type : int = Type.ICE
		equip_spell_type(new_current_type)
	if event.is_action_pressed("equip_light"):
		var new_current_type : int = Type.LIGHT
		equip_spell_type(new_current_type)


func equip_spell_type(new_current_type: int) -> void:
	if spell_index[current_spell[new_current_type]] == 0:
		return
	current_type = new_current_type
	robot_stats.current_type = current_type
	select_audios[current_type].play()
	set_spell_scene(current_spell[current_type])


func _disable() -> void:
	set_spell_scene("")
