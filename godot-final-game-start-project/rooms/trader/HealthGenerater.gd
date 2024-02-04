extends TradeProduct

func drop_product() -> void:
	spawn_point.get_child(0).queue_free()
	var moving_item := MovingItem.new()
	var product : Pickup = product_path.instance()
	moving_item.global_position = spawn_point.global_position
	get_tree().current_scene.add_child(moving_item)
	moving_item.add_child(product)
	
	moving_item.spawn_position += 100.0
	choose_random_product()
	audio.play()
