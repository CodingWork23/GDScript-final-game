# Plays an animation when the player enters its area and calls the teleport()
# function on the body that entered. Any additional functionality has to be
# provided by the body.
class_name Teleporter
extends Area2D

# This scene holds the teleporter's animation.
const TeleportFx := preload("teleport_fx/TeleportFx.tscn")

# when activated, the teleporter plays a little "lighting up" animation.
export var is_active := false setget set_is_active

# When the player gets close, we light up the teleporter with an animation.
onready var _animation_player := $AnimationPlayer

var score_is_reached := false
var no_mobs := false


func _ready() -> void:
	_animation_player.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")
	connect("body_entered", self, "_on_body_entered")
	#Events.connect("no_mobs_in_view", self, "_no_mobs_in_view")


# Either plays the activation animation or remove the activation highlights.
func set_is_active(new_state: bool) -> void:
	if new_state == is_active:
		return
	is_active = new_state
	if is_active:
		_animation_player.play("activation")
	else:
		_animation_player.play("RESET")


# When a body enters, play the teleport FX, and call the teleport() function on
# the body
func _on_body_entered(body: Node) -> void:
	var teleport_fx := TeleportFx.instance()
	add_child(teleport_fx)
	# We set the FX at the location of the body. We just offset it a little bit
	# down because it looks better this way
	teleport_fx.global_position = body.global_position + Vector2(0, 4)
	
	# If the body has no teleport() function, nothing happens.
	if body.has_method("teleport"):
		body.teleport()

# Called, if the waves are deffeted
func _no_mobs_in_view() -> void:
	set_is_active(true)
	


# Once the short activation animation finishes, we play the looping "activate"
# animation.
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "activation":
		_animation_player.play("activate")
