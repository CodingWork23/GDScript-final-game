extends Spell

onready var loadinng_timer := $LoadingTimer

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("shoot") and _cooldown_timer.is_stopped():
		shoot()
	if not loadinng_timer.is_stopped():
		Events.emit_signal("set_transform", global_transform)

func shoot() -> void:
	var bullet: Bullet = bullet_scene.instance()
	get_tree().root.add_child(bullet)
	bullet.global_transform = global_transform
	bullet.max_range = max_range
	bullet.speed = max_bullet_speed
	
	loadinng_timer.start()
	_cooldown_timer.start()
