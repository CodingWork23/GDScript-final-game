extends Sword

const SHOCK_AREA := preload("res://mobs/hammer/Explosion.tscn")

var colliding_with_target : bool = false

func _dash(delta: float) -> void:
	if is_attacking:
		_velocity = vector * speed * dash_factor
		_velocity = move_and_slide(_velocity)
		distance += speed * delta
		if distance > max_distance or colliding_with_target:
			distance = 0
			is_attacking = false
			_cooldown_timer.start()
			prepare_for_attack = false
			_sprite_alert.visible = false
			colliding_with_target = false
			shock()
		return

func _checking_within_range() -> void:
	_sprite.flip_on_turning()
	._checking_within_range()

func shock() -> void:
	var Shock_Area := SHOCK_AREA
	var shock_area := Shock_Area.instance()
	shock_area.global_position = global_position
	
	get_tree().root.add_child(shock_area)
	
	health += shock_area.damage

func _on_Hitbox_body_entered(body: Node2D) -> void:
	._on_Hitbox_body_entered(body)
	if is_attacking:
		colliding_with_target = true
