extends VBoxContainer

export(Texture) var bar_texture : Texture = null

export var bar_count := 6 setget set_bar_count


func _ready() -> void:
	Events.connect("set_heal_power", self, "set_bar_count")
	
	redraw_bars()

func set_bar_count(new_count: int) -> void:
	bar_count = new_count
	redraw_bars()

func redraw_bars() -> void:
	for bar in get_children():
		bar.queue_free()
	
	for _i in range(bar_count):
		var bar := TextureRect.new()
		
		bar.texture = bar_texture
		bar.size_flags_vertical = 0
		bar.rect_min_size.y = 18.0
		bar.expand = true
		bar.modulate = Color(0.427451, 0.996078, 0)
		bar.material = preload("res://particles/light_texture.tres")
		
		add_child(bar)
