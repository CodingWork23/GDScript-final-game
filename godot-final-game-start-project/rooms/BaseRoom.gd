# This is the base script each room should use or extend.
#
# It takes care of spawing enemies and items, but can also optionally spawn a
# player and a teleporter.
#
# It also handles hiding and showing bridges.
#
# Note: we would rather call this class "Room", but there is already a node
# named Room in Godot, so we cannot use that name.
class_name BaseRoom
extends Node2D


export var game_events : Resource = null
# Default size of the rectangle encompassing bridges drawn in the tilemap, to
# erase the ones that don't lead to a room.
const BRIDGES_DEFAULT_SIZE := Vector2(2, 2)

# The tiles indices in the "invisible wall" tileset
const INVISIBLE_WALL_TILE_INDEX := 1
const INVISIBLE_LEDGE_TILE_INDEX := 0

# We use Rect2 values to represents the regions of the tile map where we drew
# bridges. This allows us to erase bridges that are outside of the game grid
# (the ones that don't lead to a room).
export var top_bridge := Rect2(Vector2(5, -2), BRIDGES_DEFAULT_SIZE)
export var right_bridge := Rect2(Vector2(11, 4), BRIDGES_DEFAULT_SIZE)
export var left_bridge := Rect2(Vector2(-2, 4), BRIDGES_DEFAULT_SIZE)
export var bottom_bridge := Rect2(Vector2(5, 11), BRIDGES_DEFAULT_SIZE)

onready var _bridges := $bridges
onready var _limits := $Limits
onready var _mobs_spawners := $Mobs
onready var _items_spawners := $Items
onready var _loot_chests_spawner := $LootChests
onready var _spawner_robot := $SpawnerRobot
onready var _spawner_teleporter := $SpawnerTeleporter
onready var _detection_zone := $DetectionZone
onready var _doors := $Doors

onready var left_doors := $Doors/LeftDoors
onready var right_doors := $Doors/RightDoors
onready var botton_doors := $Doors/BottomDoors
onready var top_doors := $Doors/TopDoors

onready var _awaking_timer := $AwakingTimer
onready var _spawn_timer := $SpawnTimer

var mobs_count : int
var extra_waves : int
export var max_waves := 2

var waves_finished : bool = false



func _ready() -> void:
	Events.connect("set_mobs_physics", self, "_toggle_the_mobs")
	_detection_zone.connect("body_entered", self, "_on_DetectionZone_body_entered")
	_awaking_timer.connect("timeout", self, "_toggle_the_mobs", [true])
	_spawn_timer.connect("timeout", self, "next_wave")
	
	if game_events:
		max_waves = game_events.max_waves[game_events.current_difficulty]
	
	# If we instantiate this room in another scene, we want the other scene to
	# manage the robot and the teleporter.
	#
	# But if we run the room scene directly with F6, we want to spawn the player
	# and teleporter to test the room.
	randomize()
	extra_waves = randi() % max_waves
	
	var is_main_scene = get_tree().current_scene == self
	if is_main_scene:
		spawn_robot()
		spawn_teleporter()
		spawn_mobs()
		spawn_items()
		spawn_loot_chests()
		hide_top_bridge()
		hide_right_bridge()
		hide_left_bridge()
		hide_bottom_bridge()
	else:
		# hide invisible walls
		_limits.hide()
		spawn_loot_chests()


func _process(_delta: float) -> void:
	_process_counting()

func _process_counting() -> void:
	if waves_finished:
		return
	var count := 0
	for child in _mobs_spawners.get_children():
		if child is GroupNode:
			count += child.mob_count
		elif child is Mob or child is Bomb or child is Sword:
			count += 1
	mobs_count = count
	_counting_mobs()

# Spawns all the mobs
func spawn_mobs() -> void:
	for child in _mobs_spawners.get_children():
		if child is Spawner:
			child.spawn()
	#counting_mobs()
	


# Spawns all the items
func spawn_items() -> void:
	for child in _items_spawners.get_children():
		if child is Spawner:
			child.spawn()


# Spawns the player character. This should be called by the parent scene, but
# will be called by the room itself if it's run with F6.
func spawn_robot() -> void:
	_spawner_robot.spawn()


# Spawns the teleporter. This should be called by the parent scene, but will be
# called by the room itself if it's run with F6.
func spawn_teleporter() -> void:
	_spawner_teleporter.spawn()



func spawn_loot_chests() -> void:
	for child in _loot_chests_spawner.get_children():
		if child is Spawner:
			child.spawn()

# Hides a set of bridge cells within a 2D rectangle and replaces them with
# invisible walls to prevent the player from leaving the room and walking over
# the sky.
func _hide_bridge(bridge_region: Rect2) -> void:
	var start := bridge_region.position
	var end := start + bridge_region.size
	
	var x_range := range(start.x, end.x)
	var y_range := range(start.y, end.y)
	
	# We loop over all cells between
	for x in x_range:
		for y in y_range:
			var cell_coordinates := Vector2(x, y)
			# We remove the tile from the bridge tilemap. Passing -1 to the
			# set_cellv() function erases the tile at cell_coordinates.
			_bridges.set_cellv(cell_coordinates, -1)
			# In the limits tilemap, we draw an invisible wall to block the
			# player.
			_limits.set_cellv(cell_coordinates, INVISIBLE_WALL_TILE_INDEX)

	# There's a ledge at the bottom of islands, we need to add extra half-size
	# invisible walls in this case.
	if bridge_region == bottom_bridge:
		for x in range(start.x, end.x):
			var ledge_cell_coordinates := Vector2(x, bottom_bridge.position.y - 1)
			_limits.set_cellv(ledge_cell_coordinates, INVISIBLE_LEDGE_TILE_INDEX)


func hide_top_bridge() -> void:
	_hide_bridge(top_bridge)
	top_doors.hide()
	


func hide_left_bridge() -> void:
	_hide_bridge(left_bridge)
	left_doors.hide()


func hide_right_bridge() -> void:
	_hide_bridge(right_bridge)
	right_doors.hide()


func hide_bottom_bridge() -> void:
	_hide_bridge(bottom_bridge)
	botton_doors.hide()

func _toggle_the_mobs(toggle: bool) -> void:
	for mob in _mobs_spawners.get_children():
		if mob is GroupNode:
			mob._set_mobs_physics(toggle)
		elif mob is Mob or mob is Bomb or mob is Sword:
			mob.set_physics_process(toggle)
			if toggle == false:
				mob.collision_layer = 0
			else:
				mob.collision_layer = mob.COLLISION_LAYER

func kill_mobs() -> void:
	for mob in _mobs_spawners.get_children():
		if mob is GroupNode:
			mob._die()
		elif mob is Mob or mob is Bomb or mob is Sword:
			mob._die()

func disable_mob_spawning() -> void:
	for spawner in _mobs_spawners.get_children():
		if spawner is Spawner:
			spawner.dropped_allready = true

func open_doors() -> void:
	for child in _doors.get_children():
		for door in child.get_children():
			door._open()
		
func close_doors() -> void:
	for child in _doors.get_children():
		for door in child.get_children():
			door._close()

func _counting_mobs() -> void:
	if mobs_count <= 0 and _spawn_timer.is_stopped():
		if extra_waves == 0 and not waves_finished:
			open_doors()
			spawn_items()
			waves_finished = true
			Events.emit_signal("no_mobs_in_view")
			for child in get_children():
				if child is Teleporter:
					child.set_is_active(true)
		elif extra_waves > 0:
			extra_waves -= 1
			_spawn_timer.start()
			
			

func next_wave() -> void:
	spawn_mobs()
	_toggle_the_mobs(false)
	_awaking_timer.start()
	
func _on_DetectionZone_body_entered(body: Robot) -> void:
	if mobs_count <= 0:
		return
	_toggle_the_mobs(true)
	close_doors()
	#if not Events.is_connected("died_in_baseroom", self, "_counting_mobs"):
	#	Events.connect("died_in_baseroom", self, "_counting_mobs")
	_detection_zone.disconnect("body_entered", self, "_on_DetectionZone_body_entered")
	
