extends Gem

func _on_robot_pickup(robot: Robot) -> void:
	._on_robot_pickup(robot)
	
	robot.loot_gold_gem(gem_value)
