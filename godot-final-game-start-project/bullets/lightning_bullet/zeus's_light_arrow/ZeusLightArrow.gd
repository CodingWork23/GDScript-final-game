extends Bullet

onready var collision_shape := $CollisionShape2D
onready var animation_player := $AnimationPlayer
onready var shoot_sound := $ShootSound

var bullet_activ := false

func _ready() -> void:
	collision_mask = 2
	animation_player.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")
	Events.connect("set_transform", self, "_stay_in_position")
	


func _move(delta: float) -> void:
	if not bullet_activ:
		return
	._move(delta)

func _on_AnimationPlayer_animation_finished(animation: String) -> void:
	if animation == "loading":
		bullet_activ = true
		collision_shape.disabled = false
		animation_player.play("spawn")
		shoot_sound.play()
		Events.disconnect("set_transform", self, "_stay_in_position")

func _stay_in_position(spell_holder_position) -> void:
	global_transform = spell_holder_position

func _destroy() -> void:
	animation_player.play("destroy")
	_disable()
	_audio.play()

func _on_body_entered(body: Node) -> void:
	_hit_body(body)
	_audio.play()
