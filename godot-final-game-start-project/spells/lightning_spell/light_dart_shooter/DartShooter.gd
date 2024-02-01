extends Spell

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("shoot") and _cooldown_timer.is_stopped():
		for _i in range(_bullet_count):
			shoot()
		_cooldown_timer.start()
		
		Events.emit_signal("set_spell_cooldown", _cooldown_timer.wait_time)
	
