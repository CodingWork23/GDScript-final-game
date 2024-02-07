extends Control

export var robot_stats : Resource = null

onready var restart_button := $CenterContainer/VBoxContainer/RestartButton
onready var quit_button := $CenterContainer/VBoxContainer/QuitButton

func _ready() -> void:
	if robot_stats:
		robot_stats.reset_stats()
	quit_button.connect("pressed", get_tree(), "change_scene", ["res://interface/menu/MainMenu.tscn"])
	restart_button.connect("pressed", get_tree(), "change_scene", ["res://Main.tscn"])
