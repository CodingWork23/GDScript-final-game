extends Bullet

onready var animation_player := $AnimationPlayer

export var freeze_power := 100.0

func _ready() -> void:
	animation_player.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")
	animation_player.play("spawn")
	#damage = 3

func _destroy() -> void:
	animation_player.play("destroy")
	_audio.play()
	_disable()
	

func _on_AnimationPlayer_animation_finished(animation: String) -> void:
	if animation == "destroy":
		queue_free()

func _hit_body(body: Node) -> void:
	if body.has_method("_start_freezing"):
		body._start_freezing(freeze_power)
	._hit_body(body)
