extends TextureProgress


func _ready() -> void:
	Events.connect("boss_health_changed", self, "set_health")
	Events.connect("set_boss_max_health", self, "set_max_health")
	Events.connect("visible_bar", self, "set_visibility")

func set_max_health(new_value: int) -> void:
	max_value = new_value
	value = new_value

func set_health(new_value: int) -> void:
	value = new_value

func set_visibility(status: bool) -> void:
	visible = status
