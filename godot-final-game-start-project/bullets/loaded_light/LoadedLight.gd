extends Bullet

onready var animation_player := $AnimationPlayer

var bullet_released := false

var _transform

func _ready() -> void:
	
	Events.connect("set_transform", self, "_set_position_degree")

func _destroy() -> void:
	_disable()
	animation_player.play("Destroy")
	_audio.play()

func _move(delta: float) -> void:
	if bullet_released:
		._move(delta)
	else:
		_stay_in_position()
	
	
func releasing_bullet() -> void:
	bullet_released = true
	animation_player.play("shoot")
	Events.emit_signal("play_shoot_sound")

func loading_power(power: int) -> void:
	damage += power

func _set_position_degree(g_transform) -> void:
	_transform = g_transform

func _stay_in_position() -> void:
	if not _transform:
		return
	global_transform = _transform

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("shoot"):
		releasing_bullet()
