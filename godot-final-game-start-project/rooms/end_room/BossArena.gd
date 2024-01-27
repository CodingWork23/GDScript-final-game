extends BaseRoom

onready var isolated_doors := $IsolatedDoors
onready var emblem_spawner := $SpawnerEmblem

onready var door_states := {
	1 : [
		$IsolatedDoors/Door3,
		$IsolatedDoors/Door4,
		$IsolatedDoors/Door5
	],
	2 : [
		$IsolatedDoors/Door1,
		$IsolatedDoors/Door5,
		$IsolatedDoors/Door6
	],
	3 : [
		$IsolatedDoors/Door1,
		$IsolatedDoors/Door2,
		$IsolatedDoors/Door6
	]
}

var arena_state := 0 setget set_arena_state

func _ready() -> void:
	_toggle_the_mobs(false)
	emblem_spawner.spawn()
	Events.connect("next_arena_state", self, "_next_arena_state")
	Events.connect("boss_died", self, "set_arena_state", [0])
	Events.connect("boss_died", self, "kill_mobs")

func start_game() -> void:
	spawn_robot()
	spawn_teleporter()
	left_doors.queue_free()
	right_doors.queue_free()

func _toggle_the_mobs(toggle: bool) -> void:
	._toggle_the_mobs(toggle)
	Events.emit_signal("visible_bar", toggle)

func set_arena_state(new_state: int) -> void:
	if new_state > 3:
		arena_state = 0
	else:
		arena_state = new_state
	
	if not arena_state in door_states:
		reopen_doors()
		return
	reopen_doors()
	for child in door_states[arena_state]:
		for door in child.get_children():
			door._close()
	
	

func _next_arena_state(boss_died: bool = false) -> void:
	set_arena_state(arena_state + 1)
	spawn_mobs()
	spawn_items()

func reopen_doors() -> void:
	for child in isolated_doors.get_children():
		for door in child.get_children():
			if door.animation_player.current_animation == "red_beam_blink":
				door._reopen()


