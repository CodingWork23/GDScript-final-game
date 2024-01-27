extends Label

export(Resource) var game_events : Resource = null

func _ready() -> void:
	text = "Level: " + str(game_events.current_level) + " / " + str(game_events.level_amount)
