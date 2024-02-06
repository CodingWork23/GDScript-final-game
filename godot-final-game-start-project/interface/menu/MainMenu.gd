extends Control


export(Resource) var game_events : Resource = null
export(Resource) var robot_stats : Resource = null


onready var animation_player := $AnimationPlayer

onready var button_new_game := $CenterContainer/VBoxContainer/NewGameButton
onready var button_continue_game := $CenterContainer/VBoxContainer/ContinueGameButton
onready var button_quit := $CenterContainer/VBoxContainer/QuitButton


func _ready() -> void:
	assert(game_events != null and robot_stats != null, "There is no Resource(s) in the export var")
	
	animation_player.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")
	
	button_new_game.connect("pressed", self, "_on_NewGameButton_pressed")
	button_continue_game.connect("pressed", self, "_on_ContinueGameButton_pressed")
	button_quit.connect("pressed", self, "_on_QuitButton_pressed")
	
	animation_player.play("start")
	animation_player.queue("hover")
	

#func _on_AnimationPlayer_animation_finished(animation: String) -> void:
#	if animation == "start":
		


func _on_NewGameButton_pressed() -> void:
	robot_stats.reset_stats()
	game_events.reset_level()
	
	get_tree().change_scene("res://Main.tscn")

func _on_ContinueGameButton_pressed() -> void:
	get_tree().change_scene("res://Main.tscn")

func _on_QuitButton_pressed() -> void:
	get_tree().quit()
