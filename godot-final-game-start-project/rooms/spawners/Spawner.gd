class_name Spawner
extends Sprite

export(Array, PackedScene) var list := []


var dropped_allready := false

func _ready() -> void:
	texture = null

func spawn() -> void:
	if dropped_allready or not list:
		return	
	randomize()
	
	var random_scene_index := randi() % list.size()
	var scene : PackedScene = list[random_scene_index]
	
	if not scene:
		return
	var node : Node2D = scene.instance()
	
	#get_parent().call_deferred("add_child", node)
	get_parent().add_child(node)
	node.global_position = global_position
	#node.set_deferred("global_position", global_position)
	
	dropped_allready = true
