extends Bullet

export var poisen_duration := 10.0
export var poisen_hit_count := 3.0

onready var _animation_player := $AnimationPlayer
onready var shoot_sound := $ShootSound

onready var left_cannon := $LeftCannon
onready var right_cannon := $RightCannon


func _ready() -> void:
	_animation_player.play("spawn")

func _move(delta: float) -> void:
	var distance := speed * delta
	var motion := transform.x * speed * delta

	position += motion

	_travelled_distance += distance
	
	if int(_travelled_distance) % 100 == 0:
		_shoot()
	
	if _travelled_distance > max_range:
		_destroy()


func _shoot() -> void:
	var left_bullet : Bullet = preload("res://bullets/fire_bullet/chemical_bullet/ChemicalBullet.tscn").instance()
	left_bullet.speed = speed / 3
	left_bullet.max_range = 200
	left_bullet.global_transform = left_cannon.global_transform
	left_bullet.collision_mask = collision_mask
	
	var right_bullet : Bullet = preload("res://bullets/fire_bullet/chemical_bullet/ChemicalBullet.tscn").instance()
	right_bullet.speed = speed / 3
	right_bullet.max_range = 200
	right_bullet.global_transform = right_cannon.global_transform
	right_bullet.collision_mask = collision_mask
	
	get_tree().root.add_child(left_bullet)
	get_tree().root.add_child(right_bullet)
	
	shoot_sound.play()


func _hit_body(body: Node) -> void:
	._hit_body(body)
	if body.has_method("_start_poisen"):
		body._start_poisen(poisen_duration, poisen_hit_count)

func _destroy():
	_disable()
	_audio.play()
	_animation_player.play("destroy")

func _on_body_entered(body: Node) -> void:
	_hit_body(body)
