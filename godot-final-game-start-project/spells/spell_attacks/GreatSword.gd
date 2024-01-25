extends YSort

export(int, 0, 20) var damage := 2

onready var great_sword := $DergeePoint/GreatSword

func _ready() -> void:
	great_sword.connect("body_entered", self, "_on_Area2D_body_entered")

func _on_Area2D_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
