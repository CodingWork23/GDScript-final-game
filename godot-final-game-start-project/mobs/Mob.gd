# Base class for mobs. Defines some functions you can reuse to create different
# kinds of mobs.
class_name Mob
extends KinematicBody2D

onready var _spawn_effect : Particles2D = $SpawnEffect
# The damage this mob inflicts when it hits the player.
export var damage := 1
# How much damage the mob can take before dying.
export var health := 2 setget set_health
# How much points the mob gives when killed.
export var points := 10
# How far from the player this mob will orbit. The export hint in parentheses limits
# The minimum and maximum orbit distance you can choose.
export (float, 100.0, 400.0, 1.0) var orbit_distance := 200.0
# Movement speed in pixels per second.
export(float, 50.0, 750.0, 1.0) var normal_speed := 250.0

export(Array, PackedScene) var mob_loot := []
export var max_item_count := 2

var item_count : int

onready var speed : float = normal_speed
var freeze_color := Color(0.241699, 0.921192, 0.9375)
var poisen_color := Color(0.478431, 0.992157, 0.498039)
# This will be set if the robot is in view
var _target: Robot = null
# if the robot can be attacked
var _target_within_range := false

# The velocity of the enemy
var _velocity := Vector2.ZERO
# How fast the enemy can react
var _drag_factor := 6.0
# Detects when player is close
const COLLISION_LAYER := 2

onready var _detection_area := $DetectionArea
# Detects when player is within attack range; smaller than detection area.
onready var _attack_area := $AttackArea
# Plays a sound when the mob dies.
onready var _die_sound := $DieSound
# Wind-up time just before attacking.
onready var _before_attack_timer := $BeforeAttackTimer
# Waiting time before attacking again.
onready var _cooldown_timer := $CoolDownTimer
# The enemy sprite itself. Unused in the base mob, but can be useful in
# inherited mobs.
onready var _sprite := $Sprite


# Another sprite that is visible when the enemy is alerted. Can be a different
# color, a "!" sign, anything.
onready var _sprite_alert := $Sprite/Alert
# The animation player.
onready var _animation_player := $AnimationPlayer

onready var _ray_cast : RayCast2D = $RayCast2D

onready var _freeze_timer := $FreezeTimer
onready var poisen_timer := $PoisenTimer


func _ready() -> void:
	# This area detects when the player gets in range of the mob. Use it to play
	# "wake-up" style animations, or get the mob to track the player.
	_detection_area.connect("body_entered", self, "_on_DetectionArea_body_entered")
	_detection_area.connect("body_exited", self, "_on_DetectionArea_body_exited")
	# This is another area that detects when the player gets within attack range.
	_attack_area.connect("body_entered", self, "_on_AttackArea_body_entered")
	_attack_area.connect("body_exited", self, "_on_AttackArea_body_exited")
	# We connect the die sound to call queue_free after it
	_die_sound.connect("finished", self, "_on_DieSound_finished")
	# There's a little wind up before attacking, and we attack once it times out.
	_before_attack_timer.connect("timeout", self, "_on_BeforeAttackTimer_timeout")
	_cooldown_timer.connect("timeout", self, "_on_CoolDownTimer_timeout")
	# if timeout, then freeze out
	_freeze_timer.connect("timeout", self, "_on_FreezeTimer_timeout")
	# _sprite_alert is when the player is in view. We start out with it invisible.
	_sprite_alert.visible = false
	
	_spawn_effect.emitting = true
	randomize()
	item_count = randi() % max_item_count


# This function can be used to know if the mob can attack.
#
# A mob can attack if and only if:
#
# 1. The player is in view.
# 2. The cooldown timer is not running.
# 3. The wind-up to attach timer is not running.
func is_ready_to_attack() -> bool:
	return (
		_target
		and _cooldown_timer.is_stopped()
		and _before_attack_timer.is_stopped()
		and target_within_ray_cast()
	)

func target_within_ray_cast() -> bool:
	return (
		_ray_cast.is_colliding() 
		and _ray_cast.get_collider() == _target
	)

func timers_out() -> bool:
	return (
		_target
		and _cooldown_timer.is_stopped()
		and _before_attack_timer.is_stopped()
		and not _ray_cast.is_enabled()
	)

# Steers towards the target position. Use this to follow the player, or any
# other point of interest for the mob.
func follow(target_global_position: Vector2) -> void:
	var desired_velocity := global_position.direction_to(target_global_position) * speed
	var steering := desired_velocity - _velocity
	_velocity += steering / _drag_factor
	_velocity = move_and_slide(_velocity, Vector2.ZERO)


# Orbit around the target if there is one.
func orbit_target() -> void:
	if not _target:
		return
	var direction := _target.global_position.direction_to(global_position)
	var offset_from_target := direction.rotated(PI / 6.0) * orbit_distance
	follow(_target.global_position + offset_from_target)

func set_health(new_health: int) -> void:
	health = clamp(new_health, 0, 999)

# Called by bullets.
func take_damage(amount: int, _ghost_effect: bool = true) -> void:
	set_health(health - amount)
	if health <= 0:
		_die()
	else:
		_animation_player.stop()
		_animation_player.play("hit")
		_animation_player.queue("hover")


# Disables the mob, plays the "die" animation and the "die" sound. Emits
# "mob_died" the global event bus, which will relay it. When the "die" sound
# finishes, the mob is removed.
func _die() -> void:
	_disable()
	_animation_player.play("die")
	_die_sound.play()
	Events.emit_signal("died_in_baseroom")
	if health <= 0 and item_count:
		for _i in range(item_count):
			_drop_loot()

func _drop_loot() -> void:
	if not mob_loot:
		return
	randomize()
	var random_inventory_index := randi() % mob_loot.size()
	var item : Pickup = mob_loot[random_inventory_index].instance()
	var moving_item := MovingItem.new()
	var landing_position = moving_item.landing_position
	
	get_tree().current_scene.add_child(moving_item)
	moving_item.global_position = global_position
	moving_item.spawn_position = global_position.y + rand_range(-landing_position, landing_position)
	moving_item.add_child(item)

# Disables the mob. We remove anything that can trigger collisions again and
# leave the monster as an invisible wall. This is useful if you want to play
# death animations or sounds before queue_free, but don't want the mob to act
# anymore
func _disable() -> void:
	collision_layer = 0
	collision_mask = 0
	
	_detection_area.set_deferred("monitoring", false)
	_detection_area.set_deferred("monitorable", false)
	_detection_area.collision_layer = 0
	_detection_area.collision_mask = 0
	
	_attack_area.set_deferred("monitoring", false)
	_attack_area.set_deferred("monitorable", false)
	_attack_area.collision_mask = 0
	_attack_area.collision_layer = 0
	
	_cooldown_timer.stop()
	_before_attack_timer.stop()
	
	set_physics_process(false)


# When the die sound finishes playing, we can remove the mob.
func _on_DieSound_finished() -> void:
	queue_free()


# When the player enters the detection area, we set the _target variable and
# show the _sprite_alert node.
func _on_DetectionArea_body_entered(body: Robot) -> void:
	_target = body
	#_sprite_alert.visible = true


# When the player exists the detection area, we set _target to null and hide the
# _sprite_alert.
#
# If you want a mob that doesn't let the player go after seeing it, override
# this method and set it to pass. Then the mob will remember the player forever.
func _on_DetectionArea_body_exited(_body: Robot) -> void:
	_target = null
	_sprite_alert.visible = false


# Called when the player is within attack range.
func _on_AttackArea_body_entered(body: Robot) -> void:
	_target_within_range = true


# Called when the player exits attack range.
func _on_AttackArea_body_exited(_body: Robot) -> void:
	_target_within_range = false


# Called when the wind-up before attacking has ran out. The mob should now
# attack.
func _on_BeforeAttackTimer_timeout() -> void:
	pass


# Called when the attack was launched and recovered from. The mob is ready to
# attack again now.
func _on_CoolDownTimer_timeout() -> void:
	pass


func _start_freezing(freeze_power: float) -> void:
	_freeze_timer.start()
	speed = normal_speed / (freeze_power / 100.0 + 1.0)
	_sprite.modulate = freeze_color
	_sprite_alert.modulate = freeze_color

func _on_FreezeTimer_timeout() -> void:
	speed = normal_speed
	_sprite.modulate = Color(1, 1, 1)
	_sprite_alert.modulate = Color(1, 1, 1)

func _start_poisen(poisen_duration: float, poisen_hit_count: float) -> void:
	if not poisen_timer.is_stopped():
		poisen_timer.start()
		return
	var poisen_range := (poisen_duration - 1) / poisen_hit_count
	poisen_timer.wait_time = poisen_duration
	_sprite.modulate = poisen_color
	_sprite_alert.modulate = poisen_color
	
	poisen_timer.start()
	
	
	while(not poisen_timer.is_stopped()):
		yield(get_tree().create_timer(poisen_range), "timeout")
		if health > 1 and not poisen_timer.is_stopped():
			take_damage(1)
	
	_sprite.modulate = Color(1, 1, 1)
	_sprite_alert.modulate = Color(1, 1, 1)
