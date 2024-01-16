extends Pickup

export(float, 1.0, 20.0, 1.0) var heal_value := 10.0
export(float, 1.0, 300.0, 1.0) var duration := 60.0


func _on_robot_pickup(robot: Robot) -> void:
	_disable()
	robot._start_regeneration(duration, heal_value)
	_audio.play()
	_animation_player.play("destroy")
