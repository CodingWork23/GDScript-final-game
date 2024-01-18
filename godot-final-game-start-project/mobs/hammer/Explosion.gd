extends Area2D

export var damage := 2

onready var animation_player := $AnimationPlayer

func _ready() -> void:
	connect("body_entered", self, "_on_Explosion_body_entered")
	animation_player.play("explode")

func _on_Explosion_body_entered(body: Node2D) -> void:
	#yield(self, "ready")
	if body.has_method("take_damage"):
		body.take_damage(damage)
