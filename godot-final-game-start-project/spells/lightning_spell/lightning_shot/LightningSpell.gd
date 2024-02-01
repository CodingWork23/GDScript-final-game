extends Spell


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") and _cooldown_timer.is_stopped():
		_cooldown_timer.start()
		shoot()
		Events.emit_signal("set_spell_cooldown", _cooldown_timer.wait_time)
