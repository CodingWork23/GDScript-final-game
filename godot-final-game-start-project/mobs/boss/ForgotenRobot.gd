extends Mob

var max_health : int

var first_phase := true
var second_phase := true
var third_phase := true

func _ready() -> void:
	Events.emit_signal("set_boss_max_health", health)
	max_health = health

func set_health(new_health: int) -> void:
	.set_health(new_health)
	if float(health) < float(max_health) * 0.75 and first_phase:
		Events.emit_signal("spawn_mobs")
		first_phase = false
	if health < max_health * 0.50 and second_phase:
		Events.emit_signal("spawn_mobs")
		second_phase = false
	if health < max_health * 0.25 and third_phase:
		Events.emit_signal("spawn_mobs")
		third_phase = false
	
	Events.emit_signal("boss_health_changed", health)

func _on_DieSound_finished() -> void:
	queue_free()
	Events.emit_signal("visible_bar", false)
