class_name UIHealKit
extends HBoxContainer

export var kit_full : Texture
export var kit_empty : Texture

export var max_heal_kit := 2 setget set_max_heal_kit
export var heal_kit := 0 setget set_heal_kit


func _ready() -> void:
	_redraw_kit_bar()

func set_max_heal_kit(new_max_kit: int) -> void:
	max_heal_kit = new_max_kit
	_redraw_kit_bar()
	

func set_heal_kit(new_kit: int) -> void:
	heal_kit = clamp(new_kit, 0, max_heal_kit)
	_redraw_kit_bar()

func _redraw_kit_bar() -> void:
	# Because we use individual TextureRect nodes to draw health points, to
	# redraw the bar, we delete all the existing nodes and create new ones with
	# the appropriate texture.
	for child in get_children():
		child.queue_free()

	# We need as many nodes as there is max_health: one texture per health
	# point.
	for index in max_heal_kit:
		var kit_slot := TextureRect.new()
		# As long as index is below or equal to health, draw a full kit_slot.
		if index < heal_kit:
			kit_slot.texture = kit_full
		# When index is higher than health, draw an empty kit_slot.
		else:
			kit_slot.texture = kit_empty
		kit_slot.mouse_filter = 2
		add_child(kit_slot)
