# The base node representing all pickups.
#
# This class takes care of:
#
# 1. Detecting the player body.
# 2. Detecting the player's SpellHolder area.
#
# That's it. Whatever happens when either a body or an area enters is up to the
# script that inherit this class.
class_name Pickup
extends Area2D

onready var _audio := $AudioStreamPlayer2D
onready var _animation_player := $AnimationPlayer
onready var spawn_effect := $SpawnEffect

var _spell_holder : SpellHolder = null

func _ready() -> void:
	connect("body_entered", self, "_on_robot_pickup")
	connect("area_entered", self, "_on_spell_holder_pickup")
	connect("area_exited", self, "_on_SpellPickup_area_exited")
	_animation_player.play("idle")
	spawn_effect.emitting = true

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("picking_up") and _spell_holder != null:
		loot_spell_pickup(_spell_holder)

# Virtual function (scripts that extend this class should override this
# function). Called when the Robot touches the pickup.
func _on_robot_pickup(robot: Robot) -> void:
	pass


# Virtual function. Called when the Robot's SpellHolder touches the pickup.
func _on_spell_holder_pickup(holder: SpellHolder) -> void:
	if not holder is SpellHolder:
		return
	_spell_holder = holder
	

func _on_SpellPickup_area_exited(holder: SpellHolder) -> void:
	if not holder is SpellHolder:
		return
	_spell_holder = null

func loot_spell_pickup(holder: SpellHolder) -> void:
	pass

# Call this when someone loots the pickup to prevent it from getting looted
# twice. This is important if you want to play an animation before freeing the pickup.
func _disable() -> void:
	# The set_deferred() function waits for the end of the current frame to change the property 
	# in quotes to the value passed as the second argument.
	#
	# You need that for some physics properties or Godot will give you an error.
	# Turning off monitoring and monitorable will prevent the area from detecting anything else.
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
	disconnect("body_entered", self, "_on_robot_pickup")
	disconnect("area_entered", self, "_on_spell_holder_pickup")
