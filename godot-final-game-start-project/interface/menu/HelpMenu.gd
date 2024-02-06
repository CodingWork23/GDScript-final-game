extends Control

signal close

onready var cancel_button := $Button

func _ready() -> void:
	cancel_button.connect("pressed", self, "_on_Cancel_button_pressed")

func _on_Cancel_button_pressed() -> void:
	emit_signal("close")
