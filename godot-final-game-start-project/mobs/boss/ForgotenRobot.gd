extends Mob

onready var great_sword_timer := $GreatSwordTimer
onready var flame_blow_cannon := $FlameBlow
onready var flame_blow_timer := $FlameBlowTimer
onready var flame_blast_cannon := $FlameBlast
onready var flame_blast_timer := $FlameBlastTimer

onready var attack_animation := $AttackAnimation
onready var flame_sound := $FlameSound

var max_health : int
var slow_speed := 200.0

var first_phase := true
var second_phase := true
var third_phase := true

var is_attacking := false
var attack_in_process := false

func _ready() -> void:
	Events.emit_signal("set_boss_max_health", health)
	max_health = health

func _physics_process(delta: float) -> void:
	if not _target or is_attacking:
		return
	follow(_target.global_position)
	_ray_cast.look_at(_target.global_position)
	
	if attack_in_process:
		return
	
	if _target_within_range:
		swing_sword()
		flame_blow()
	else:
		flame_blast()
	

func swing_sword() -> void:
	if not is_ready_to_attack() or not great_sword_timer.is_stopped():
		return
	
	var great_sword := preload("res://spells/spell_attacks/SwordAttack.tscn").instance()
	great_sword.rotation_degrees -= 90
	_ray_cast.add_child(great_sword)
	_sprite_alert.visible = true
	speed -= slow_speed
	attack_in_process = true
	
	yield(great_sword, "tree_exited")
	
	_sprite_alert.hide()
	speed = normal_speed
	attack_in_process = false
	
	_cooldown_timer.start()
	great_sword_timer.start()
	

func flame_blow() -> void:
	if not is_ready_to_attack() or not flame_blow_timer.is_stopped():
		return
	_sprite_alert.show()
	is_attacking = true
	attack_animation.play("flame_blow")
	
	yield(attack_animation,"animation_finished")
	
	flame_sound.play()
	for _i in range(flame_blow_cannon.bullet_count):
		flame_blow_cannon.shoot_at_target(_target)
	attack_animation.play("RESET")
	_sprite_alert.hide()
	is_attacking = false
	
	_cooldown_timer.start()
	flame_blow_timer.start()
	
func flame_blast() -> void:
	if not is_ready_to_attack() or not flame_blast_timer.is_stopped():
		return
	_sprite_alert.show()
	speed -= slow_speed
	attack_animation.play("flame_blow")
	attack_in_process = true
	
	yield(attack_animation,"animation_finished")
	
	for _i in range(50):
		flame_blast_cannon.shoot_at_target(_target)
		flame_sound.play()
		yield(get_tree().create_timer(0.1), "timeout")
	attack_animation.play("RESET")
	speed = normal_speed
	_sprite_alert.hide()
	attack_in_process = false
	
	_cooldown_timer.start()
	flame_blast_timer.start()


func set_health(new_health: int) -> void:
	.set_health(new_health)
	if health < max_health * 0.75 and first_phase:
		Events.emit_signal("spawn_mobs")
		first_phase = false
	if health < max_health * 0.50 and second_phase:
		Events.emit_signal("spawn_mobs")
		second_phase = false
	if health < max_health * 0.25 and third_phase:
		Events.emit_signal("spawn_mobs")
		third_phase = false
	
	Events.emit_signal("boss_health_changed", health)

func _on_DieSound_finished() -> void:
	queue_free()
	Events.emit_signal("visible_bar", false)

func _on_DetectionArea_body_entered(body: Robot) -> void:
	._on_DetectionArea_body_entered(body)
	_sprite._target = body
