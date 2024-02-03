extends Bomb


func _target_in_view() -> void:
	follow(_target.global_position)
	#if is_ready_to_attack():
	#	_before_attack_timer.start()
	
	if _target_within_range:
		_sprite_alert.visible = true
		_animation_player.play("explode")
		explode_sound.play()
		_disable()
		Events.emit_signal("died_in_baseroom")
	
func _die() -> void:
	_disable()
	_animation_player.play("explode")
	explode_sound.play()
	Events.emit_signal("died_in_baseroom")
	if health <= 0 and item_count:
		for _i in range(item_count):
			_drop_loot()
	
func _on_ShockArea_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage, false)
	if body is Robot:
		Events.emit_signal("flash_screen")

func _on_BeforeAttackTimer_timeout() -> void:
	pass
