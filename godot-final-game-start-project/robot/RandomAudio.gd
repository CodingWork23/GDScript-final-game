extends AudioStreamPlayer2D

export(Array, AudioStream) var sounds := []

func play(from_position = 0.0) -> void:
	if sounds:
		stream = sounds[randi() % sounds.size()]
	.play(from_position)
