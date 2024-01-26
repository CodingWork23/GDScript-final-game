extends Sprite

const DIRECTION_TO_FRAME := {
	Vector2.DOWN: 0,
	Vector2.DOWN + Vector2.RIGHT: 1,
	Vector2.RIGHT: 2,
	Vector2.UP + Vector2.RIGHT: 3,
	Vector2.UP: 4,
}

const SPRITE_SHEET := [
	preload("res://mobs/boss/sprites/boss_bottom.png"),
	preload("res://mobs/boss/sprites/boss_bottom_right.png"),
	preload("res://mobs/boss/sprites/boss_right.png"),
	preload("res://mobs/boss/sprites/boss_up_right.png"),
	preload("res://mobs/boss/sprites/boss_up.png")
]

const SPRITE_SHEET_CHARGE := [
	preload("res://mobs/boss/sprites/boss_bottom_charged.png"),
	preload("res://mobs/boss/sprites/boss_bottom_right_charged.png"),
	preload("res://mobs/boss/sprites/boss_right_charged.png"),
	preload("res://mobs/boss/sprites/boss_up_right_charged.png"),
	preload("res://mobs/boss/sprites/boss_up_charged.png")
]

# The sprite leans forward when moving. This limits its angle.
const MAX_LEANING_ANGLE := PI / 12.0

onready var sprite_alert := $Alert

var _target : Robot = null


func _physics_process(delta: float) -> void:
	if not _target:
		return
	var direction := global_position.direction_to(_target.global_position)
	var direction_key := direction.round()
	direction_key.x = abs(direction_key.x)
	if direction_key in DIRECTION_TO_FRAME:
		var sprite_sheet_index : int = DIRECTION_TO_FRAME[direction_key]
		texture = SPRITE_SHEET[sprite_sheet_index]
		sprite_alert.texture = SPRITE_SHEET_CHARGE[sprite_sheet_index]
		flip_h = sign(direction.x) == -1
		sprite_alert.flip_h = sign(direction.x) == -1
	
	# Makes the character lean towards its move direction.
	rotation = lerp(rotation, direction.x * MAX_LEANING_ANGLE, 20.0 * delta)


#func die() -> void:
#	set_physics_process(false)
