class_name SpinningCannon
extends Position2D

enum Target {NONE, ROBOT, MOB}

export(Target) var _target := Target.NONE

export var bullet_scene: PackedScene

export(float, 0.5, 20.0, 0.1) var duration := 1.0
export(float, 0.1, 4.0, 0.1) var spin_speed := 1.5
export(float, 1.0, 20.0, 1.0) var bullet_per_seconds := 5.0
export (float, 0.0, 360.0, 1.0) var random_angle_degrees := 10.0
export (float, 100.0, 2000.0, 1.0) var max_range := 1000.0
export (float, 100.0, 3000.0, 1.0) var max_bullet_speed := 800.0

func _ready() -> void:
	set_cannon_stats()
	
	prepare_exiting()
		

func set_cannon_stats() -> void:
	for cannon in get_children():
		cannon.bullet_scene = bullet_scene
		cannon.shoot_duration_timer.wait_time = duration
		cannon.shoot_rate_timer.wait_time = 1.0 / bullet_per_seconds
		cannon.random_angle_degrees = random_angle_degrees
		cannon.max_range = max_range
		cannon.max_bullet_speed = max_bullet_speed
		cannon._target = _target
		cannon._audio.volume_db = -1
		
		cannon.start_spray()

func prepare_exiting() -> void:
	yield(get_tree().create_timer(duration), "timeout")
	queue_free()

func _physics_process(delta: float) -> void:
	rotate_cannons()

func rotate_cannons() -> void:
	rotation_degrees += spin_speed
