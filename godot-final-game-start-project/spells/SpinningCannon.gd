extends Position2D

export var duration := 1.0
export var spin_speed := 2.0

func _ready() -> void:
	for cannon in get_children():
		cannon.shoot_duration_timer.wait_time = duration
		cannon.start_spray()

func _physics_process(delta: float) -> void:
	rotation_degrees += spin_speed
