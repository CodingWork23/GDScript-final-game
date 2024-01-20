extends Sword


func _on_BeforeAttackTimer_timeout() -> void:
	._on_BeforeAttackTimer_timeout()
	_animation_player.play("spin")
	_animation_player.queue("hover")

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		_die()
	elif _animation_player.current_animation == "hover":
		_animation_player.stop()
		_animation_player.play("hit")
		_animation_player.queue("hover")

func _checking_within_range() -> void:
	if _target_within_range:
		_prepare_to_attack()
	follow(_target.global_position)
