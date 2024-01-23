extends BaseRoom


func _ready() -> void:
	_toggle_the_mobs(false)
	Events.connect("spawn_mobs", self, "spawn_mobs")

func start_game() -> void:
	spawn_robot()
	spawn_teleporter()
	left_doors.queue_free()
	right_doors.queue_free()

func _toggle_the_mobs(toggle: bool) -> void:
	._toggle_the_mobs(toggle)
	Events.emit_signal("visible_bar", toggle)
