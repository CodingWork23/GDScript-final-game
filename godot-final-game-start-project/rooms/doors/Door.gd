extends StaticBody2D

onready var animation_player := $AnimationPlayer

func _ready() -> void:
	animation_player.play("RESET")

func _close() -> void:
	animation_player.play("close")
	animation_player.queue("red_beam_blink")

func _open() -> void:
	animation_player.play("open")
	animation_player.queue("green_beam_blink")
