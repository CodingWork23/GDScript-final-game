extends Bullet

onready var animation_player := $AnimationPlayer
onready var collision := $CollisionShape2D

func _ready() -> void:
	animation_player.play("spawn")
	collision.disabled = false

func _destroy() -> void:
	_disable()
	animation_player.play("destroy")
	_audio.play()
