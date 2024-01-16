extends Spawner

export var game_events : Resource = null

export(float, 0.0, 100.0, 1.0) var spawn_chance := 50.0

func _ready() -> void:
	if game_events:
		spawn_chance = game_events.mob_spawn_chance[game_events.current_difficulty]
		list = game_events.mob_list[game_events.current_difficulty]

func spawn() -> void:
	if get_random_number() > spawn_chance or dropped_allready:
		return
	.spawn()
	dropped_allready = false

func get_random_number() -> float:
	randomize()
	var random_number := randf() * 100.0
	return random_number
