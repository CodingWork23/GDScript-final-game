extends YSort

onready var spawners := $Spawners

func _ready() -> void:
	randomize()
	for spawner in spawners.get_children():
		if spawner.has_method("spawn"):
			spawner.spawn()
