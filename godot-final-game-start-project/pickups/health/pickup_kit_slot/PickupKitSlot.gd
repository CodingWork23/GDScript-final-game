extends Pickup

func _on_robot_pickup(robot: Robot) -> void:
	robot.add_kit_slot()
	_disable()
	_animation_player.play("destroy")

