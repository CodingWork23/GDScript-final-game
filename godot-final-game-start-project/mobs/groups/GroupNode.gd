class_name GroupNode
extends YSort

var mob_count : int

func _ready() -> void:
	for _mob in get_children():
		mob_count += 1
	  

func _process(_delta: float) -> void:
	if not get_children():
		queue_free()

func _set_mobs_physics(status: bool) -> void:
	for mob in get_children():
		mob.set_physics_process(status)
		if status == false:
			mob.collision_layer = 0
		else:
			mob.collision_layer = mob.COLLISION_LAYER

func _die() -> void:
	for mob in get_children():
		mob._die()
