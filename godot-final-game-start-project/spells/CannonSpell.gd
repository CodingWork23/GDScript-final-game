extends Spell

enum Target {NONE, ROBOT, MOB}

const Bullet_Masks := {
	Target.NONE : 16,
	Target.ROBOT : 17,
	Target.MOB : 18
}

onready var shoot_rate_timer := $ShootRateTimer
onready var shoot_duration_timer := $ShootDurationTimer
onready var hand_right := $HandRight
onready var hand_left := $HandLeft

export(Target) var _target := Target.NONE
var bullet_per_sec := 5.0 #setget set_bullet_per_sec



func _ready() -> void:
	#set_bullet_per_sec(bullet_per_sec)
	
	
	shoot_rate_timer.connect("timeout", self, "shoot")
	shoot_duration_timer.connect("timeout", self, "stop_shooting")
	
	hand_left.texture = null
	hand_right.texture = null

func set_bullet_per_sec(new_value: float) -> void:
	bullet_per_sec = new_value
	yield(self, "ready")
	shoot_rate_timer.wait_time = 1.0 / bullet_per_sec

func start_spray() -> void:
	#yield(self, "ready")
	shoot()
	shoot_duration_timer.start()

#var ready_to_shoot : bool = _cooldown_timer.is_stopped() and shoot_duration_timer.is_stopped()
	
	
func shoot() -> void:
	var bullet: Bullet = bullet_scene.instance()
	get_tree().root.add_child(bullet)
	bullet.global_transform = global_transform
	bullet.max_range = max_range
	bullet.speed = max_bullet_speed
	bullet.randomize_rotation(deg2rad(random_angle_degrees))
	_audio.play()
	bullet.collision_mask = Bullet_Masks[_target]
	
	shoot_rate_timer.start()


func stop_shooting() -> void:
	shoot_rate_timer.stop()
	_cooldown_timer.start()
