extends Main


onready var boss_arena : BaseRoom = $BossArena

func generate_level() -> void:
	pass

func _ready() -> void:
	boss_arena.start_game()
	Events.emit_signal("visible_bar", false)

func on_ready_function() -> void:
	_animation_player.play("start_game")
	_music_player.play()
	_pause_screen.hide()
