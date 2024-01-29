extends Bullet

export var poisen_duration := 10.0
export var poisen_hit_count := 3.0

onready var _animation_player := $AnimationPlayer


func _ready() -> void:
	_animation_player.play("spawn")


func _hit_body(body: Node) -> void:
	._hit_body(body)
	if body.has_method("_start_poisen"):
		body._start_poisen(poisen_duration, poisen_hit_count)

func _destroy():
	_disable()
	_audio.play()
	_animation_player.play("destroy")
