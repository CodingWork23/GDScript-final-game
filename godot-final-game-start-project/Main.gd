extends YSort

export var game_events : Resource = null

export(Array, PackedScene) var rooms := []
export var grid_width := 2
export var grid_height := 2
export var room_size := Vector2(13, 13) * 128

onready var _music_player := $MusicPlayer
onready var _pause_screen := $CanvasLayer/PauseScreen
onready var _ui_screen := $CanvasLayer/OnScreenUI
onready var _animation_player := $AnimationPlayer
onready var _interface_effect := $InterfaceEffect

onready var last_room_index := (grid_width * grid_height) - 1
var current_room_index := 0

func _ready() -> void:
	if game_events:
		grid_width = game_events.grid_width[game_events.current_difficulty]
		grid_height = game_events.grid_height[game_events.current_difficulty]
		last_room_index = (grid_width * grid_height) - 1
	
	generate_level()
	_music_player.play()
	_pause_screen.hide()
	_animation_player.play("overview")
	_animation_player.queue("start_game")
	
	_animation_player.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")
	Events.connect("end_game", self, "_end_game")
	Events.connect("next_game", self, "_next_game")
	Events.connect("flash_screen", self, "_flash_screen")

func generate_level() -> void:
	randomize()
	for y in range(grid_height):
		for x in range(grid_width):
			randomize()
			
			var room_position := Vector2(x, y)
			
			
			#spawn a room
			var RoomScene : PackedScene = rooms[randi() % rooms.size()]
			var room : BaseRoom = RoomScene.instance()
			add_child(room)
			
			#set room's position
			room.global_position = room_position * room_size
			
			#spawning objects
			if current_room_index == 0:
				room.spawn_robot()
				room.spawn_items()
				room.disable_mob_spawning()
			elif current_room_index == last_room_index:
				room.spawn_teleporter()
				room.spawn_mobs()
			else:
				room.spawn_items()
				room.spawn_mobs()
			
			#hiding bridges
			if x == 0:
				room.hide_left_bridge()
			elif x == grid_width - 1:
				room.hide_right_bridge()
			if y == 0:
				room.hide_top_bridge()
			elif y == grid_height - 1:
				room.hide_bottom_bridge()
			
			Events.emit_signal("set_mobs_physics", false)
			
			current_room_index += 1

func _on_AnimationPlayer_animation_finished(animation: String) -> void:
	if animation == "end_game":
		game_events.current_level = 1
		game_events.current_difficulty = 0
		get_tree().change_scene("res://interface/GameOver.tscn")
	
	if animation == "next_game":
		if game_events.current_level == game_events.level_amount:
			game_events.current_level = 1
			game_events.current_difficulty = 0
			get_tree().change_scene("res://interface/WinGame.tscn")
		else:
			game_events.increase_difficulty()
			game_events.next_level()
			get_tree().change_scene("res://Main.tscn")

func toggle_the_game(toggle: bool) -> void:
	_ui_screen.visible = toggle
	Events.emit_signal("set_current_camera", toggle)
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and _animation_player.current_animation == "overview":
		_animation_player.seek(INF)
		set_process_unhandled_input(false)

func _end_game() -> void:
	_animation_player.play("end_game")

func _next_game() -> void:
	_animation_player.play("next_game")

# Interface Effect
func _flash_screen() -> void:
	if _interface_effect.is_playing():
		_interface_effect.seek(0)
	else:
		_interface_effect.play("flash_screen")
