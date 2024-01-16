extends Bullet


onready var animation_player := $AnimationPlayer
onready var hitbox := $Hitbox

func _ready():
	animation_player.play("spawn")
	hitbox.connect("body_entered", self, "_on_Hitbox_body_entered")


func _move(delta: float) -> void:
	if speed > 50:
		speed /= 1.02
	._move(delta)

func _on_Hitbox_body_entered(body: Node) -> void:
	_hit_body(body)

func _destroy() -> void:
	animation_player.play("destroy")
	

func _on_body_entered(body: Node) -> void:
	_destroy()
	_audio.play()

