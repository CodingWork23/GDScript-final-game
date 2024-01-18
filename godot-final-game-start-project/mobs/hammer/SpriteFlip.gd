extends Sprite

onready var alert_sprite := $Alert

var sprite_rotation := rotation setget set_sprite_rotation

func _physics_process(_delta: float) -> void:
	set_sprite_rotation(rotation)

func set_sprite_rotation(new_rotation: float) -> void:
	if new_rotation > PI:
		new_rotation = -PI
	elif new_rotation < -PI:
		new_rotation = PI
	sprite_rotation = new_rotation
	rotation = sprite_rotation

func flip_on_turning() -> void:
	var turned : bool = sprite_rotation > PI/2 or sprite_rotation < -PI / 2
	if turned:
		flip_v = true
		alert_sprite.flip_v = true
	else:
		flip_v = false
		alert_sprite.flip_v = false
