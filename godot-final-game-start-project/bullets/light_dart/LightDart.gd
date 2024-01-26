extends Bullet

onready var animation_player := $AnimationPlayer
onready var shoot_sound := $ShootSound

var bullet_released := false

var target : Robot = null

func _move(delta: float) -> void:
	if bullet_released:
		._move(delta)
	elif target:
		look_at(target.global_position)

func releasing_bullet() -> void:
	bullet_released = true
	shoot_sound.play()

func _destroy() -> void:
	animation_player.play("destroy")
	_audio.play()
	_disable()
