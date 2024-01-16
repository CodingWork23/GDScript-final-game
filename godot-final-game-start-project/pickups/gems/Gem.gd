class_name Gem
extends Pickup

export var gem_value := 1
export var speed := 1000.0

onready var follow_zone := $FollowZone

var robot : Robot = null

func _ready() -> void:
	follow_zone.connect("body_entered", self, "_on_FollowZone_body_entered")
	follow_zone.connect("body_exited", self, "_on_FollowZone_body_exited")

func _physics_process(delta: float) -> void:
	follow(delta)

func follow(delta: float) -> void:
	if not robot:
		return
	var distance := robot.global_position.distance_to(global_position) / 10
	var direction_vector := global_position.direction_to(robot.global_position)
	var velocity := (direction_vector * speed) / distance
	global_position += velocity * delta

func _on_robot_pickup(_robot: Robot) -> void:
	_disable()
	_animation_player.play("destroy")
	_audio.play()

func _on_FollowZone_body_entered(body: Robot) -> void:
	robot = body

func _on_FollowZone_body_exited(_body: Robot) -> void:
	robot = null
