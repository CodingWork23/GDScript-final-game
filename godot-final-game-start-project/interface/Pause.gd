# The pause screen. It should exist in the main game scene but start hidden.
#
# Pressing the "pause" input action will show this screen and pause everything
# else.
extends Control

export var robot_stats : Resource = null

onready var _button_continue := $CenterContainer/VBoxContainer/ContinueButton
onready var _button_restart := $CenterContainer/VBoxContainer/RestartButton
onready var _button_quit := $CenterContainer/VBoxContainer/QuitButton

func _ready() -> void:
	_button_continue.connect("pressed", self, "_on_ContinueButton_pressed")
	_button_quit.connect("pressed", self, "_on_QuitButton_pressed")
	_button_restart.connect("pressed", self, "_on_RestartButton_pressed")

func _on_QuitButton_pressed() -> void:
	if robot_stats:
		robot_stats.reset_stats()
	get_tree().quit()

func _on_RestartButton_pressed() -> void:
	if robot_stats:
		robot_stats.reset_stats()
	get_tree().reload_current_scene()
	get_tree().paused = false

func _on_ContinueButton_pressed() -> void:
	get_tree().paused = false
	hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = true
		show()
