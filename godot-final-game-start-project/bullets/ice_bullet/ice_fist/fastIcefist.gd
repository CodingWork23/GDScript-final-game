extends Bullet

onready var animation_player := $AnimationPlayer

export var freeze_power := 100.0

func _ready() -> void:
	animation_player.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")
	animation_player.play("spawn")
	speed /= 10



func _destroy() -> void:
	animation_player.play("destroy")
	_audio.play()
	_disable()

func _move(delta: float) -> void:
	var distance := speed * delta
	var motion := transform.x * speed
	speed *= 1.1

	position += motion * delta

	_travelled_distance += distance
	if _travelled_distance > max_range:
		_destroy()

func _on_AnimationPlayer_animation_finished(animation: String) -> void:
	if animation == "destroy":
		queue_free()

func _hit_body(body: Node) -> void:
	if body.has_method("_start_freezing"):
		body._start_freezing(freeze_power)
	._hit_body(body)
