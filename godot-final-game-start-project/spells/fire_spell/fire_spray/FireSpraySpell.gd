extends Spell


export(float, 1.0, 20.0, 1.0) var bullet_per_sec := 5.0

onready var shoot_rate_timer := $ShootRateTimer
onready var shoot_duration_timer := $ShootDurationTimer

func _ready() -> void:
	shoot_rate_timer.wait_time = 1 / bullet_per_sec
	
	shoot_rate_timer.connect("timeout", self, "shoot")
	shoot_duration_timer.connect("timeout", self, "stop_shooting")

func _unhandled_input(event: InputEvent) -> void:
	var ready_to_shoot : bool = _cooldown_timer.is_stopped() and shoot_duration_timer.is_stopped()
	
	if event.is_action_pressed("shoot") and ready_to_shoot:
		shoot()
		shoot_duration_timer.start()
	
func shoot() -> void:
	.shoot()
	shoot_rate_timer.start()

func stop_shooting() -> void:
	shoot_rate_timer.stop()
	_cooldown_timer.start()
	Events.emit_signal("set_spell_cooldown", _cooldown_timer.wait_time)
