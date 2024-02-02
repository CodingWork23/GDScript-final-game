class_name SpellBasicFire
extends Spell


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("shoot") and _cooldown_timer.is_stopped():
		shoot()


func shoot() -> void:
	_cooldown_timer.start()
	.shoot()
	Events.emit_signal("set_spell_cooldown", _cooldown_timer.wait_time)
