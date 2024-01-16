extends Pickup

func _on_robot_pickup(robot: Robot) -> void:
	_disable()
	_audio.play()
	robot.add_heal_kit()
	_animation_player.play("destroy")
