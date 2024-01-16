class_name MovingItem
extends KinematicBody2D

export var gravity := 1500.0
export var jump_power := 600.0
export var fall_direction := 200.0
export var landing_position := 50.0

onready var area := $Area2D
var obstacle : PhysicsBody2D = null

var rand_fall_direction : float
var rand_landing_position : float
var spawn_position : float

var velocity := Vector2.ZERO


func _ready() -> void:
	velocity.y = -jump_power
	randomize()
	rand_fall_direction = rand_range(-fall_direction, fall_direction)
	rand_landing_position = rand_range(-landing_position, landing_position)
	spawn_position = global_position.y + rand_landing_position
	
	if area:
		area.connect("body_entered", self, "_on_Area2D_body_entered")
		area.connect("body_exited", self, "_on_Area2D_body_exited")
	
#func _process(delta: float) -> void:
#	if get_child_count() <= 2:
#		queue_free()

func _physics_process(delta: float) -> void:
	_move(delta)
	

func _move(delta: float) -> void:
	
	if global_position.y > spawn_position and velocity.y > 0 and not obstacle:
		set_physics_process(false)
	
	velocity.y += gravity * delta
	velocity.x = rand_fall_direction
	
	move_and_slide(velocity)


func _on_Area2D_body_entered(body: PhysicsBody2D) -> void:
	obstacle = body

func _on_Area2D_body_exited(_body: PhysicsBody2D) -> void:
	obstacle = null

