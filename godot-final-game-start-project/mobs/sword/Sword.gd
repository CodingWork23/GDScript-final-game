class_name Sword
extends Mob

onready var hitbox := $Sprite/Hitbox
onready var dash_sound := $DashSound
onready var hitbox_timer := $Sprite/Hitbox/Timer
onready var hitbox_collision := $Sprite/Hitbox/CollisionShape2D

export var max_distance := 50
export(float, 1, 5) var dash_factor := 4.0
export var _ray_cast_enabled := false

var distance := 0
var is_attacking := false
var prepare_for_attack := false
var vector : Vector2

func _ready() -> void:
	hitbox.connect("body_entered", self, "_on_Hitbox_body_entered")
	hitbox_timer.connect("timeout", self, "_hitbox_enable")

func _physics_process(delta: float) -> void:
	_dash(delta)
	
	if not _target or prepare_for_attack:
		return
	_ray_cast.look_at(_target.global_position)
	if _ray_cast_enabled:
		if not _ray_cast.is_colliding() or _ray_cast.get_collider() != _target or not _before_attack_timer.is_stopped():
			return
	
	_sprite.look_at(_target.global_position)
	
	_checking_within_range()

func _checking_within_range() -> void:
	if _target_within_range:
		_prepare_to_attack()
		orbit_target()
	else:
		follow(_target.global_position)

func _dash(delta: float) -> void:
	if is_attacking:
		_velocity = vector * speed * dash_factor
		_velocity = move_and_slide(_velocity)
		distance += speed * delta
		if distance > max_distance:
			distance = 0
			is_attacking = false
			_cooldown_timer.start()
			prepare_for_attack = false
			_sprite_alert.visible = false
		return

func _prepare_to_attack() -> void:
	if not is_ready_to_attack():
		return
	_before_attack_timer.start()
	_sprite_alert.visible = true
	vector = global_position.direction_to(_target.global_position)
	prepare_for_attack = true

func _on_BeforeAttackTimer_timeout() -> void:
	is_attacking = true
	dash_sound.play()

func _on_Hitbox_body_entered(body: Node2D) -> void:
	#hitbox_timer.start()
	#hitbox_collision.disabled = true
	if body.has_method("take_damage"):
		body.take_damage(damage)
	

func _hitbox_enable() -> void:
	hitbox_collision.disabled = false

func _on_DetectionArea_body_entered(body: Robot) -> void:
	_target = body
	
func _on_DetectionArea_body_exited(_body: Robot) -> void:
	pass

func _disable() -> void:
	._disable()
	hitbox.collision_mask = 0
