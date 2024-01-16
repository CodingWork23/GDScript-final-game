class_name Bomb
extends Mob

onready var explode_sound := $ExplodeSound
onready var shock_area := $ShockArea
onready var _cannon := $Cannon
onready var shoot_sound := $ShootSound

export var _ray_cast_enabled := false
export var bullet_count := 3

func _ready() -> void:
	_animation_player.connect("animation_finished", self, "_explode")
	explode_sound.connect("finished", self, "_on_DieSound_finished")
	shock_area.connect("body_entered", self, "_on_ShockArea_body_entered")

func _physics_process(delta: float) -> void:
	if not _target:
		return
	
	_ray_cast.look_at(_target.global_position)
	if _ray_cast_enabled:
		if not _ray_cast.is_colliding() or _ray_cast.get_collider() != _target:
			return
	
	_target_in_view()
	

func _target_in_view() -> void:
	_cannon.look_at(_target.global_position)
	
	if is_ready_to_attack() or timers_out():
		_before_attack_timer.start()
		_sprite_alert.visible = true
	
	if _target_within_range:
		_animation_player.play("will_explode")
		_disable()
		

func _explode(animation: String) -> void:
	if animation == "will_explode":
		_animation_player.play("explode")
		explode_sound.play()
		Events.emit_signal("died_in_baseroom")
		#if _target and _target.has_method("take_damage"):
		#	_target.take_damage(damage)

func _on_DetectionArea_body_entered(body: Robot) -> void:
	_target = body

func _on_ShockArea_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)

func _on_BeforeAttackTimer_timeout() -> void:
	_sprite_alert.visible = false
	if not _target:
		return
	_cooldown_timer.start()
	shoot_sound.play()
	for _i in range(bullet_count):
		_cannon.shoot_at_target(_target)

func _on_DetectionArea_body_exited(_body: Robot) -> void:
	pass

func _die() -> void:
	_disable()
	_animation_player.play("will_explode")
	if health <= 0 and item_count:
		for _i in range(item_count):
			_drop_loot()
