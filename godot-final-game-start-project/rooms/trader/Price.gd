extends TraderGuy

export var health_price := 600

export var extra_price := 150


func _buy_product(robot: Robot, product_path: PackedScene, self_path: Node2D) -> void:
	if not product_path in product_prices:
		return
	var price : int = get_price()
	if robot.gold_gems < price or not is_active:
		return
	robot.buy_product(price)
	self_path.drop_product()
	game_events.increase_extra_payment()
	health_price += extra_price
	_show_price(product_path)


func _show_price(product_path: PackedScene) -> void:
	if not product_path:
		return
	var price : String = str(get_price())
	
	price_label.text = price
	if animation_player.is_playing():
		animation_player.queue("show_price")
	else:
		animation_player.play("show_price")


func get_price() -> int:
	return health_price + game_events.extra_payment
