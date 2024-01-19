extends Sword


func _on_BeforeAttackTimer_timeout() -> void:
	._on_BeforeAttackTimer_timeout()
	_animation_player.play("spin")

func _on_Hitbox_body_entered(body: Node2D) -> void:
	hitbox_timer.start()
	hitbox_collision.disabled = true
	if body.has_method("take_damage"):
		body.take_damage(damage, false)
