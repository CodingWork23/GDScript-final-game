class_name LootChest
extends StaticBody2D

export(Array, PackedScene) var chest_inventory := []
export(Array, PackedScene) var last_gems := []
export(int, 0, 20) var max_item_count := 3
export(int, 0, 10) var max_last_item_count := 1

onready var chest_full := $ChestEmpty/ChestFull
onready var detection_zone := $DetectionZone

var robot : Robot = null
var item_count : int
var last_item_count : int

func _ready() -> void:
	item_count = (randi() % max_item_count) + 1
	last_item_count = (randi() % max_last_item_count) + 1
	#if not item_count:
	#	item_count = 1
	assert(chest_inventory.size() > 0, "Chest has no Loot inside his Inventory")
	detection_zone.connect("body_entered", self, "_on_DetectionZone_body_entered")
	detection_zone.connect("body_exited", self, "_on_DetectionZone_body_exited")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("picking_up") and robot:
		open_chest()

func open_chest() -> void:
	loot_chest()

func loot_chest() -> void:
	chest_full.hide()
	for _i in range(item_count):
		drop_item()
	item_count = 0
	if not last_gems:
		_disable()
		return
	for _i in range(last_item_count):
		drop_last_item()
	_disable()


func drop_item() -> void:
	randomize()
	var random_inventory_index := randi() % chest_inventory.size()
	var item : Pickup = chest_inventory[random_inventory_index].instance()
	var moving_item := MovingItem.new()
	moving_item.collision_mask = 48
	moving_item.fall_direction = 150
	
	add_child(moving_item)
	moving_item.add_child(item)
	
	moving_item.spawn_position += 80

func drop_last_item() -> void:
	randomize()
	var random_inventory_index := randi() % last_gems.size()
	var item : Pickup = last_gems[random_inventory_index].instance()
	var moving_item := MovingItem.new()
	moving_item.collision_mask = 48
	moving_item.fall_direction = 150
	
	add_child(moving_item)
	moving_item.add_child(item)
	
	moving_item.spawn_position += 80


func _on_DetectionZone_body_entered(body: Robot) -> void:
	robot = body

func _on_DetectionZone_body_exited(_body: Robot) -> void:
	robot = null

func _disable() -> void:
	detection_zone.monitoring = false
	set_process_unhandled_input(false)
