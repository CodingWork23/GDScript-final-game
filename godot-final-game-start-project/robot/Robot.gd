# The player class.
#
# The node only does two things:
#
# 1. It moves and collides
# 2. It handles health, and dying
#
# The shooting is handled by a completely different node with completely
# independent code.
#
# The Sprite direction is handled automatically, also independently
class_name Robot
extends KinematicBody2D


enum Emblems {NONE, ROBOT, SWORD, MACE, HAMMER}

export var robot_stats : Resource = null

export(Emblems) var current_emblem := Emblems.NONE setget set_current_emblem
var robot_emblem_is_active : bool = false setget set_robot_emblem_is_active
var sword_emblem_is_active : bool = false

export var max_heal_kit := 2 setget set_max_heal_kit
export var heal_kit := 1 setget set_heal_kit

export var heal_power := 6
# The character's speed in pixels per second.
export var normal_speed := 650.0
# Controls how quickly the body reaches its desired velocity. A value of 1 makes
# the character move instantly at its maximum speed.
export(float, 0.01, 1.0) var drag_factor := 0.12
export(float, 1.0, 8.0, 0.25) var dash_factor := 4.0
export(float, 50.0, 500.0, 1.0) var max_distance := 150.0

export(int, 0, 9999) var gold_gems := 0

# The health property uses a setter to ensure that it never goes above
# max_health or below 0.
var max_health := 10 setget set_max_health
var health := max_health setget set_health


var velocity := Vector2.ZERO
var desired_velocity : Vector2
var distance : float

onready var speed := normal_speed

var freeze_color := Color(0.241699, 0.921192, 0.9375)
var poisen_color := Color(0.478431, 0.992157, 0.498039)
var current_color := Color(1, 1, 1)

onready var _camera: ShakingCamera2D = $ShakingCamera2D
onready var _damage_audio = $DamageAudio
onready var _death_audio = $DeathAudio
onready var _heal_sound := $HealSound
onready var _dash_sound := $DashSound
onready var _skin := $Skin
onready var _smoke_particles := $SmokeParticles
onready var _spell_holder := $SpellHolder
onready var _animation_emblem := $AnimationEmblem
onready var _robot_collision := $CollisionShape2D

onready var _ghost_timer := $GhostTimer
onready var _freeze_timer := $FreezeTimer
onready var _poisen_duration := $PoisenDurationTimer
onready var _poisen_range := $PoisenRangeTimer
onready var _regeneration_timer := $RegenerationTimer
onready var _heal_timer := $HealTimer
onready var _emblem_cooldown_timer := $EmblemCooldownTimer


func _ready() -> void:
	show()
	if robot_stats:
		#max_health = robot_stats.max_health
		heal_power = robot_stats.heal_power
		
		set_max_health(robot_stats.max_health)
		set_health(robot_stats.health)
		set_max_heal_kit(robot_stats.max_heal_kit)
		set_heal_kit(robot_stats.heal_kit)
		set_gold_gems(robot_stats.gold_gems)
		set_current_emblem(robot_stats.current_emblem)
	else:
		set_health(max_health)
		set_heal_kit(heal_kit)
	#_death_audio.connect("finished", get_tree(), "change_scene", ["res://interface/GameOver.tscn"])
	Events.emit_signal("set_max_health", max_health)
	Events.emit_signal("player_health_changed", health)
	Events.connect("set_current_camera", self, "_set_current_camera")
	Events.connect("end_game", self, "_disable")
	# Effects
	_freeze_timer.connect("timeout", self, "_on_FreezeTimer_timeout")
	_poisen_range.connect("timeout", self, "_take_poisen_damage")
	_poisen_duration.connect("timeout", self, "healing_poisen")
	_regeneration_timer.connect("timeout", self, "_stop_regeneration")
	_heal_timer.connect("timeout", self, "_heal_regeneration")
	_ghost_timer.connect("timeout", self, "stop_ghost_effect")
	
	#set_current_emblem(1)


# This is the same steering movement code you used since the start of the
# course.
func _physics_process(delta: float) -> void:
	if sword_emblem_is_active:
		velocity = desired_velocity * dash_factor
		velocity = move_and_slide(velocity, Vector2.ZERO)
		distance += speed * delta
		if distance > max_distance:
			sword_emblem_is_active = false
			distance = 0.0
		return
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	desired_velocity = speed * direction
	var steering := desired_velocity - velocity
	velocity += steering * drag_factor
	
	velocity = move_and_slide(velocity, Vector2.ZERO)
	_smoke_particles.emitting = velocity.length() > speed / 2.0

func set_max_health(new_max_health: int) -> void:
	max_health = new_max_health
	if robot_stats:
		robot_stats.max_health = max_health
	Events.emit_signal("set_max_health", max_health)
# Health setter, we make sure health is always between 0 and max
func set_health(new_health: int) -> void:
	health = clamp(new_health, 0, max_health)
	if robot_stats:
		robot_stats.health = health
	Events.emit_signal("player_health_changed", health)

func increase_max_health(increase_value: int) -> void:
	set_max_health(max_health + increase_value)

func healing(heal: int) -> void:
	set_health(health + heal)
	_heal_sound.play()

func set_max_heal_kit(new_value: int) -> void:
	max_heal_kit = new_value
	Events.emit_signal("player_max_heal_kit_changed", max_heal_kit)

func set_heal_kit(new_heal_kit: int) -> void:
	heal_kit = clamp(new_heal_kit, 0, max_heal_kit)
	if robot_stats:
		robot_stats.heal_kit = heal_kit
	Events.emit_signal("player_heal_kit_changed", heal_kit)

func add_heal_kit() -> void:
	set_heal_kit(heal_kit + 1)

func use_heal_kit() -> void:
	if not heal_kit:
		return
	healing(heal_power)
	healing_poisen()
	set_heal_kit(heal_kit - 1)


func set_gold_gems(new_value: int) -> void:
	gold_gems = clamp(new_value,0 , 9999)
	if robot_stats:
		robot_stats.gold_gems = gold_gems
	Events.emit_signal("set_gold_gems", gold_gems)

func buy_product(price: int) -> void:
	set_gold_gems(gold_gems - price)

func loot_gold_gem(gem_value: int) -> void:
	set_gold_gems(gold_gems + gem_value)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("use_kit"):
		use_heal_kit()
	if event.is_action_pressed("use_ability"):
		use_emblem()

# Called by the Teleport node when we walk over it. This jumps to the win screen
# scene.
func teleport() -> void:
	_set_current_camera(false)
	hide()
	Events.emit_signal("next_game")
	


# Called by enemy bullets when they hit the robot.
func take_damage(amount: int, start_timer: bool = true) -> void:
	if health <= 0 or robot_emblem_is_active:
		return
	
	if start_timer:
		start_ghost_effect()
	
	set_health(health - amount)
	#healing(amount)
	# If the health is lower or equal to zero, we're dead, so we disable
	# movement.
	if health <= 0:
		_disable()
		# We play the death animation and sound too.
		_skin.die()
		_death_audio.play()
		_spell_holder.queue_free()
		robot_stats.reset_stats()
		Events.emit_signal("end_game")
	else:
		_damage_audio.play()
		_camera.shake_intensity += 0.6

func start_ghost_effect() -> void:
	_ghost_timer.start()
	_animation_emblem.play("ghost")
	collision_layer = 128

func stop_ghost_effect() -> void:
	collision_layer = 129

# Makes the player interact with nothing and stop receiving inputs
func _disable() -> void:
	set_process(false)
	set_physics_process(false)
	collision_layer = 0
	collision_mask = 0

func _set_current_camera(toggle_current: bool) -> void:
	_camera.current = toggle_current
	set_physics_process(toggle_current)


# Effects
# Freezing
func _start_freezing(freeze_power: float) -> void:
	_freeze_timer.start()
	speed = normal_speed / (freeze_power / 100.0 + 1.0)
	_skin.modulate = freeze_color

func _on_FreezeTimer_timeout() -> void:
	speed = normal_speed
	_skin.modulate = current_color

# Poisened
func _start_poisen(poisen_duration: int, poisen_hit_count: int) -> void:
	_poisen_duration.wait_time = poisen_duration + 1
	_poisen_range.wait_time = (_poisen_duration.wait_time - 1) / poisen_hit_count
	current_color = poisen_color
	_skin.modulate = current_color
	_poisen_duration.start()
	if _poisen_range.is_stopped():
		_poisen_range.start()
	

func _take_poisen_damage() -> void:
	if health > 1:
		take_damage(1, false)
	_poisen_range.start()

func healing_poisen() -> void:
	current_color = Color(1, 1, 1)
	_skin.modulate = current_color
	_poisen_range.stop()

# Regeneration
func _start_regeneration(duration: float, heal_value: float) -> void:
	_regeneration_timer.wait_time = duration
	_heal_timer.wait_time = duration / heal_value
	_regeneration_timer.start()
	if _heal_timer.is_stopped():
		_heal_timer.start()

func _heal_regeneration() -> void:
	healing(1)
	_heal_timer.start()

func _stop_regeneration() -> void:
	_heal_timer.stop()


# Emblems
func set_current_emblem(new_emblem: int) -> void:
	current_emblem = new_emblem
	Events.emit_signal("set_emblem_icon", current_emblem)
	if robot_stats:
		robot_stats.current_emblem = current_emblem

func use_emblem() -> void:
	if not _emblem_cooldown_timer.is_stopped():
		return
	if current_emblem == Emblems.ROBOT:
		robot_emblem()
	elif current_emblem == Emblems.SWORD:
		sword_emblem()
	elif current_emblem == Emblems.HAMMER:
		hammer_emblem()
	elif current_emblem == Emblems.MACE:
		mace_emblem()
	else:
		return

func robot_emblem() -> void:
	var cooldown := 20.0
	_emblem_cooldown_timer.wait_time = cooldown
	_emblem_cooldown_timer.start()
	robot_emblem_is_active = true
	_animation_emblem.play("robot_emblem")
	Events.emit_signal("set_emblem_cooldown", cooldown)

func set_robot_emblem_is_active(new_state: bool) -> void:
	robot_emblem_is_active = new_state

func sword_emblem() -> void:
	if not desired_velocity:
		return
	var cooldown := 5.0
	_emblem_cooldown_timer.wait_time = cooldown
	_emblem_cooldown_timer.start()
	Events.emit_signal("set_emblem_cooldown", cooldown)
	
	sword_emblem_is_active = true
	start_ghost_effect()
	_dash_sound.play()

func hammer_emblem() -> void:
	var cooldown := 15.0
	_emblem_cooldown_timer.wait_time = cooldown
	_emblem_cooldown_timer.start()
	Events.emit_signal("set_emblem_cooldown", cooldown)
	
	var Explosion := preload("res://mobs/hammer/Explosion.tscn")
	var explosion : Area2D = Explosion.instance()
	explosion.collision_mask -= 1
	explosion.global_position = global_position
	explosion.damage = 4
	
	get_tree().root.add_child(explosion)
	
	

func mace_emblem() -> void:
	var cooldown := 20.0
	_emblem_cooldown_timer.wait_time = cooldown
	_emblem_cooldown_timer.start()
	Events.emit_signal("set_emblem_cooldown", cooldown)
	
	var spinning_cannon : SpinningCannon = preload("res://spells/spell_attacks/SpinningCannon.tscn").instance()
	spinning_cannon._target = spinning_cannon.Target.MOB
	spinning_cannon.bullet_scene = preload("res://bullets/fire_spike/FireSpike.tscn")
	spinning_cannon.max_range = 500.0
	spinning_cannon.max_bullet_speed = 600.0
	
	add_child(spinning_cannon)








