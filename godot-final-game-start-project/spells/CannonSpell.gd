extends Spell

export(float, 1.0, 20.0, 1.0) var bullet_per_sec := 5.0

onready var shoot_rate_timer := $ShootRateTimer
onready var shoot_duration_timer := $ShootDurationTimer
onready var hand_right := $HandRight
onready var hand_left := $HandLeft

func _ready() -> void:
	shoot_rate_timer.wait_time = 1 / bullet_per_sec
	
	shoot_rate_timer.connect("timeout", self, "shoot")
	shoot_duration_timer.connect("timeout", self, "stop_shooting")
	
	hand_left.texture = null
	hand_right.texture = null

func start_spray() -> void:
	shoot()
	shoot_duration_timer.start()

#var ready_to_shoot : bool = _cooldown_timer.is_stopped() and shoot_duration_timer.is_stopped()
	
	
func shoot() -> void:
	.shoot()
	shoot_rate_timer.start()

func stop_shooting() -> void:
	shoot_rate_timer.stop()
	_cooldown_timer.start()
