extends Pickup

export var extra_health := 1


func _on_robot_pickup(robot: Robot) -> void:
	_disable()
	robot.increase_max_health(extra_health)
	_audio.play()
	_animation_player.play("destroy")
