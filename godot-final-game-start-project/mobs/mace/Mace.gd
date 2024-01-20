extends Sword


func _on_BeforeAttackTimer_timeout() -> void:
	._on_BeforeAttackTimer_timeout()
	_animation_player.stop()
	_animation_player.play("spin")
	_animation_player.queue("hover")
	
	var spinning_cannon : SpinningCannon = preload("res://spells/SpinningCannon.tscn").instance()
	spinning_cannon._target = spinning_cannon.Target.ROBOT
	spinning_cannon.bullet_per_seconds = 5.0
	spinning_cannon.max_bullet_speed = 500.0
	spinning_cannon.max_range = 800.0
	add_child(spinning_cannon)

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
