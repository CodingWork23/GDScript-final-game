extends Spell

var audio_disabled := false

func _ready() -> void:
	Events.connect("play_shoot_sound", self, "play_sound")

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("shoot") and _cooldown_timer.is_stopped():
		Events.emit_signal("set_transform", global_transform)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") and _cooldown_timer.is_stopped():
		audio_disabled = false
		shoot()
	if event.is_action_released("shoot") and not audio_disabled:
		_audio.play()
		audio_disabled = true
		_cooldown_timer.start()
		
		Events.emit_signal("set_spell_cooldown", _cooldown_timer.wait_time)

func shoot() -> void:
	var bullet: Bullet = bullet_scene.instance()
	get_tree().root.add_child(bullet)
	bullet.global_transform = global_transform
	bullet.max_range = max_range
	bullet.speed = max_bullet_speed
	bullet.randomize_rotation(deg2rad(random_angle_degrees))
	#bullet._set_position_degree(global_transform)

func play_sound() -> void:
	if not audio_disabled:
		_audio.play()
		audio_disabled = true
		_cooldown_timer.start()
