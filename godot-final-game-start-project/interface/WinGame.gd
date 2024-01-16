extends Control

export var robot_stats : Resource = null

onready var restart_button := $CenterContainer/VBoxContainer/RestartButton
onready var quit_button := $CenterContainer/VBoxContainer/QuitButton

func _ready() -> void:
	if robot_stats:
		robot_stats.reset_stats()
	restart_button.connect("pressed", self, "_on_RestartButton_pressed")
	quit_button.connect("pressed", self, "_on_QuitButton_pressed")

func _on_RestartButton_pressed() -> void:
	get_tree().change_scene("res://Main.tscn")

func _on_QuitButton_pressed() -> void:
	get_tree().quit()
