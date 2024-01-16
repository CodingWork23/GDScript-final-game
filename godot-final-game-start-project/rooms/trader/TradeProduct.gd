class_name TradeProduct
extends StaticBody2D

signal show_price(product_path)
signal hide_price()
signal buy_product(robot, product_path, self_path)

export(Array, PackedScene) var products := []

onready var detection_area := $DetectionArea
onready var spawn_point := $SpawnPoint
onready var audio := $AudioStreamPlayer2D

var robot : Robot = null
var product_path : PackedScene = null

func _ready() -> void:
	assert(products.size() > 0, "The object has no products")
	detection_area.connect("body_entered", self, "_on_DetectionArea_body_entered")
	detection_area.connect("body_exited", self, "_on_DetectionArea_body_exited")
	choose_random_product()

func choose_random_product() -> void:
	randomize()
	var Product : PackedScene = products[randi() % products.size()]
	var product : Pickup = Product.instance()
	product_path = Product
	
	product.monitoring = false
	spawn_point.add_child(product)
	
func drop_product() -> void:
	spawn_point.get_child(0).queue_free()
	var moving_item := MovingItem.new()
	var product : Pickup = product_path.instance()
	moving_item.global_position = spawn_point.global_position
	get_tree().current_scene.add_child(moving_item)
	moving_item.add_child(product)
	
	moving_item.spawn_position += 100.0
	product_path = null
	audio.play()
	
	_on_DetectionArea_body_exited(null)
	detection_area.disconnect("body_exited", self, "_on_DetectionArea_body_exited")
	


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("picking_up") and robot and product_path:
		emit_signal("buy_product", robot, product_path, self)


func _on_DetectionArea_body_entered(body: Robot) -> void:
	robot = body
	emit_signal("show_price", product_path)

func _on_DetectionArea_body_exited(_body: Robot) -> void:
	robot = null
	emit_signal("hide_price")
