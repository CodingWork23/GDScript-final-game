class_name GameEvents
extends Resource

enum Difficulty {EASY, MEDIUM, HARD}
export(Difficulty) var current_difficulty := Difficulty.EASY setget set_current_difficulty

export(int, 1, 10) var level_amount := 6
export var current_level := 1 setget set_current_level

# Mob Lists
export(Dictionary) var mob_list := {}

# Map Size
export(Array, int) var grid_width := [3, 4, 5]
export(Array, int) var grid_height := [2, 3, 4]
# Waves Count
export(Array, int) var max_waves := [1, 2, 3]
# Spawn Chance
export(Array, float, 0.0, 100.0, 1.0) var mob_spawn_chance := [60.0, 75.0, 80.0]
export(Array, float, 0.0, 100.0, 1.0) var miniboss_spawn_chance := [0.0, 10.0, 20.0]
export(Array, float, 0.0, 100.0, 1.0) var pickup_spawn_chance := [30.0, 35.0, 40.0]

# Trade Prices
export var extra_payment := 0 setget set_extra_payment



func save() -> void:
	ResourceSaver.save(resource_path, self)

func set_current_difficulty(new_difficulty: int) -> void:
	current_difficulty = clamp(new_difficulty, 0, Difficulty.size() - 1)
	save()

func increase_difficulty() -> void:
	if level_amount >= 6:
		if current_level % 2 == 0:
			set_current_difficulty(current_difficulty + 1)
		return
	else:
		set_current_difficulty(current_difficulty + 1)

func set_current_level(new_level: int) -> void:
	current_level = clamp(new_level, 1, level_amount)
	save()

func next_level() -> void:
	set_current_level(current_level + 1)


func set_extra_payment(new_value: int) -> void:
	extra_payment = new_value
	save()

func increase_extra_payment(increase_value: int = 25) -> void:
	set_extra_payment(extra_payment + increase_value)
