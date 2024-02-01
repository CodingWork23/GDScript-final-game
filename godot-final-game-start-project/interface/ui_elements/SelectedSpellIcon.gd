# Shows the currently selected spell. It can be set by passing it either the
# Spell's type (a number) or a spell's scene.
# If you create a new spell, make sure to add it to `scene_types`! You need to
# do this manually.
#
# This element connects to the global event bus so it can automatically switch
# spells when the player collects a new spell.
tool
class_name SelectedSpellIcon
extends HBoxContainer

# The type allows us to display text in the editor interface to check the
# different spell designs
enum Type { NONE, FLAME, ICE, LIGHTNING }

# This dictionary matches specific scenes with specific types.
# If you create a new spell, or change the location of a spell, make sure to
# update this dictionary
const scenes_types := {
	preload("res://spells/fire_spell/fire_basic/SpellBasicFire.tscn"): Type.FLAME,
	preload("res://spells/fire_spell/fire_spike/FireSpikeSpell.tscn"): Type.FLAME,
	preload("res://spells/fire_spell/fire_spray/FireSpraySpell.tscn"): Type.FLAME,
	preload("res://spells/fire_spell/chemical_weapon/ChemicalWeapon.tscn"): Type.FLAME,
	preload("res://spells/ice_spell/ice_punch/IceBasicSpell.tscn"): Type.ICE,
	preload("res://spells/ice_spell/super_ice_punch/SuperIceSpell.tscn"): Type.ICE,
	preload("res://spells/ice_spell/ice_cannon/IceCannon.tscn"): Type.ICE,
	preload("res://spells/ice_spell/atom_thrower/AtomThrower.tscn"): Type.ICE,
	preload("res://spells/lightning_spell/lightning_shot/LightningSpell.tscn"): Type.LIGHTNING,
	preload("res://spells/lightning_spell/loaded_shoot/LoadedShoot.tscn"): Type.LIGHTNING,
	preload("res://spells/lightning_spell/light_dart_shooter/DartShooter.tscn"): Type.LIGHTNING,
	preload("res://spells/lightning_spell/zeus_light_bow/ZeusLightBow.tscn"): Type.LIGHTNING
}

onready var particles := {
	preload("res://spells/fire_spell/fire_basic/SpellBasicFire.tscn"): $FlameSection/Flame/PariclesSparkle,
	preload("res://spells/fire_spell/fire_spike/FireSpikeSpell.tscn"): $FlameSection/Flame/PariclesSparkle2,
	preload("res://spells/fire_spell/fire_spray/FireSpraySpell.tscn"): $FlameSection/Flame/Particles2D,
	preload("res://spells/fire_spell/chemical_weapon/ChemicalWeapon.tscn"): $FlameSection/Flame/Particles2D,
	preload("res://spells/ice_spell/ice_punch/IceBasicSpell.tscn"): $IceSection/Ice/PariclesSparkle,
	preload("res://spells/ice_spell/super_ice_punch/SuperIceSpell.tscn"): $IceSection/Ice/PariclesSparkle2,
	preload("res://spells/ice_spell/ice_cannon/IceCannon.tscn"): $IceSection/Ice/Particles2D,
	preload("res://spells/ice_spell/atom_thrower/AtomThrower.tscn"): $IceSection/Ice/Particles2D,
	preload("res://spells/lightning_spell/lightning_shot/LightningSpell.tscn"): $LightSection/Lightning/PariclesSparkle,
	preload("res://spells/lightning_spell/loaded_shoot/LoadedShoot.tscn"): $LightSection/Lightning/PariclesSparkle2,
	preload("res://spells/lightning_spell/light_dart_shooter/DartShooter.tscn"): $LightSection/Lightning/Particles2D,
	preload("res://spells/lightning_spell/zeus_light_bow/ZeusLightBow.tscn"): $LightSection/Lightning/Particles2D,
}

# Export the type in the interface for easy visualisation
export(Type) var current_spell_type: int = Type.NONE setget set_current_spell_type

onready var _flame_icon := $FlameSection/Flame/LitIcon
onready var _ice_icon := $IceSection/Ice/LitIcon
onready var _lightning_icon := $LightSection/Lightning/LitIcon

onready var _flame := $FlameSection/Flame
onready var _ice := $IceSection/Ice
onready var _light := $LightSection/Lightning

onready var _flame_progress := $FlameSection/Flame/TextureProgress
onready var _ice_progress := $IceSection/Ice/TextureProgress
onready var _lightning_progress := $LightSection/Lightning/TextureProgress

onready var cooldown_timer := $CoolDownTimer


onready var _icon_progress := {
	Type.FLAME : _flame_progress,
	Type.ICE : _ice_progress,
	Type.LIGHTNING : _lightning_progress
}



func _ready() -> void:
	# Connect to the global event bus to change the selected visual if the player
	# picks a different spell.
	Events.connect("selected_spell_changed", self, "_set_current_spell_from_scene")
	Events.connect("set_spell_cooldown", self, "set_progress_timer")
	
	_update_icons_visibility()

func _process(delta: float) -> void:
	_icon_progress[current_spell_type].value = cooldown_timer.time_left

func hide_particles() -> void:
	for particle in _flame.get_children():
		if particle is Particles2D:
			particle.emitting = false
	for particle in _ice.get_children():
		if particle is Particles2D:
			particle.emitting = false
	for particle in _light.get_children():
		if particle is Particles2D:
			particle.emitting = false

# This function receives a scene, and matches it with a spell type to select
# the appropriate spell to show.
# CAUTION: the scene *must* be in `scenes_types`. If it isn't found, nothing
# happens.
# This function is also called from when the "selected_spell_changed" signal is
# emitted from the global Events bus.
func _set_current_spell_from_scene(scene: PackedScene) -> void:
	if scene in scenes_types:
		set_current_spell_type(scenes_types[scene])
		hide_particles()
		if scene in particles:
			#yield(self, "ready")
			var particle : Particles2D = particles[scene]
			particle.emitting = true


# Sets the visually selected spell type from a type. Uses the Type enum above
func set_current_spell_type(new_type: int) -> void:
	current_spell_type = new_type
	# this function might be called before the children icons are ready, so
	# we make sure to wait for ready
	if not is_inside_tree():
		yield(self, "ready")

	# in the editor, sometimes the children aren't available, so we make sure
	# they exist
	if _flame_icon and _ice_icon and _lightning_icon:
		_update_icons_visibility()


func set_progress_timer(sec: float) -> void:
	_icon_progress[current_spell_type].max_value = sec
	cooldown_timer.wait_time = sec
	cooldown_timer.start()

# Hides or shows icons depending on the value of _current_spell_type
func _update_icons_visibility() -> void:
	_flame_icon.visible = current_spell_type == Type.FLAME
	_ice_icon.visible = current_spell_type == Type.ICE
	_lightning_icon.visible = current_spell_type == Type.LIGHTNING
	
	_flame_progress.visible = current_spell_type == Type.FLAME
	_ice_progress.visible = current_spell_type == Type.ICE
	_lightning_progress.visible = current_spell_type == Type.LIGHTNING
