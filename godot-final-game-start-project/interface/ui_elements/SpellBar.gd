extends VBoxContainer

enum SpellType {FIRE, ICE, LIGHT}

export(StreamTexture) var spell_bar_image : StreamTexture = null
export(SpellType) var spell_type := 0

export var max_spell_bar := 1 setget set_max_spell_bar
export var spell_bar := 0 setget set_spell_bar

func _ready() -> void:
	assert(spell_bar_image != null, "The spell-bar has no texture!")
	redraw_spell_bars()
	
	Events.connect("update_max_spell_bar", self, "update_max_spell_bar")
	Events.connect("update_spell_bar", self, "update_spell_bar")
	#Events.connect("last_spell_bar", self, "redraw_last_spell_bar")
	

func set_max_spell_bar(new_value: int) -> void:
	max_spell_bar = new_value
	redraw_spell_bars()
	
func set_spell_bar(new_value: int) -> void:
	spell_bar = clamp(new_value, 0, max_spell_bar)
	redraw_spell_bars()

func update_max_spell_bar(type_index: int, update_value: int, is_last_level: bool = false) -> void:
	if type_index != spell_type:
		return
	if is_last_level:
		redraw_last_spell_bar()
		return
	set_max_spell_bar(update_value)
	
func update_spell_bar(type_index: int, update_value: int) -> void:
	if type_index != spell_type:
		return
	set_spell_bar(update_value)

func redraw_spell_bars() -> void:
	for child in get_children():
		child.queue_free()
	
	for i in range(max_spell_bar):
		var bar_image := TextureRect.new()
		bar_image.texture = spell_bar_image
		if i >= spell_bar:
			bar_image.modulate = Color(1, 1, 1, 0.15)
		
		bar_image.expand = true
		bar_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		bar_image.size_flags_vertical = 3
		
		add_child(bar_image)

func redraw_last_spell_bar() -> void:
	for child in get_children():
		child.queue_free()
	var bar_image := TextureRect.new()
	bar_image.texture = spell_bar_image
	
	bar_image.expand = true
	bar_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	bar_image.size_flags_vertical = 3
	bar_image.material = preload("res://particles/light_texture.tres")
	
	add_child(bar_image)
	
	Events.disconnect("update_max_spell_bar", self, "update_max_spell_bar")
	Events.disconnect("update_spell_bar", self, "update_spell_bar")
