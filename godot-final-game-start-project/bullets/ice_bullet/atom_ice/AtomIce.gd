extends Bullet

onready var animation_player := $AnimationPlayer
onready var explode_area := $ExplodeArea
onready var explode_sound := $ExplodeSound

export var freeze_power := 100.0
export var explode_damage := 2

func _ready() -> void:
	explode_area.connect("body_entered", self, "_on_ExplodeArea_body_entered")
	explode_sound.connect("finished", self, "queue_free")

func _destroy() -> void:
	animation_player.play("explode")
	explode_sound.play()
	_audio.play()
	_disable()
	shoot_multi_cannon()

func _hit_body(body: Node) -> void:
	if body.has_method("_start_freezing"):
		body._start_freezing(freeze_power)
	._hit_body(body)

func _on_ExplodeArea_body_entered(body: Node2D) -> void:
	if body.has_method("_start_freezing"):
		body._start_freezing(freeze_power)
	if body.has_method("take_damage"):
		body.take_damage(explode_damage)

func shoot_multi_cannon() -> void:
	var multi_cannon : SpinningCannon = preload("res://spells/spell_attacks/MultiCannon.tscn").instance()
	
	multi_cannon.global_position = global_position
	
	get_tree().root.add_child(multi_cannon)
	
