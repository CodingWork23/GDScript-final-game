extends Pickup

func _on_robot_pickup(robot: Robot) -> void:
	_disable()
	robot.increase_heal_power()
	_animation_player.play("destroy")
	_audio.play()
