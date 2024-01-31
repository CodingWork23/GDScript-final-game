extends SpinningCannon


func set_cannon_stats() -> void:
	for cannon in get_children():
		cannon.bullet_scene = bullet_scene
		cannon.shoot_duration_timer.wait_time = duration
		cannon.shoot_rate_timer.wait_time = 1.0 / bullet_per_seconds
		cannon.random_angle_degrees = random_angle_degrees
		cannon.max_range = max_range
		cannon.max_bullet_speed = max_bullet_speed
		cannon._target = _target
		cannon._audio.volume_db = -1
		
		cannon.shoot()
	

func prepare_exiting() -> void:
	#yield(get_tree().create_timer(0.3), "timeout")
	queue_free()

func rotate_cannons() -> void:
	pass
