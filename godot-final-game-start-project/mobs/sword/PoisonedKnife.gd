extends Sword

export(int, 1, 60) var poisen_duration := 10
export(int, 1, 30) var poisen_hit_count := 3

func _ready() -> void:
	_sprite.modulate = poisen_color
	_sprite_alert.modulate = poisen_color

func _on_Hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage, false)
	if body.has_method("_start_poisen"):
		body._start_poisen(poisen_duration, poisen_hit_count)
	_die()

func _on_FreezeTimer_timeout() -> void:
	speed = normal_speed
	_sprite.modulate = poisen_color
	_sprite_alert.modulate = poisen_color
