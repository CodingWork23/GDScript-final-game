extends Mob

onready var _cannon := $Cannon

onready var shoot_sound := $ShootSound

export var _ray_cast_enabled := false

func _physics_process(delta: float) -> void:
	if not _target:
		return
	
	_ray_cast.look_at(_target.global_position)
	
	if _ray_cast_enabled:
		if not _ray_cast.is_colliding() or _ray_cast.get_collider() != _target:
			return
	
	_cannon.look_at(_target.global_position)
	
	if _target_within_range:
		orbit_target()
		_prepare_to_attack()
	else:
		follow(_target.global_position)


func _prepare_to_attack() -> void:
	if not is_ready_to_attack() and not timers_out():
		return
	_before_attack_timer.start()
	_sprite_alert.visible = true

func _on_BeforeAttackTimer_timeout() -> void:
	_sprite_alert.visible = false
	var ray_cast_in_range : bool = not is_ready_to_attack() and not timers_out()
	if not _target or ray_cast_in_range:
		return
	shoot_sound.play()
	_cannon.shoot_at_target(_target)
	_cooldown_timer.start()

func _on_DetectionArea_body_entered(body: Robot) -> void:
	_target = body

func _on_DetectionArea_body_exited(_body: Robot) -> void:
	pass
