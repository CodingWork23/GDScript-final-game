class_name Emblem
extends StaticBody2D

enum Emblems {NONE, ROBOT, SWORD, MACE, HAMMER}

export(Emblems) var emblem_type := Emblems.NONE

export var price := 3000

onready var _detection_area := $DetectionArea
onready var animation_player := $AnimationPlayer
onready var price_label := $PriceHint/Label

var robot : Robot = null


func _ready() -> void:
	_detection_area.connect("body_entered", self, "_on_DetectionArea_body_entered")
	_detection_area.connect("body_exited", self, "_on_DetectionArea_body_exited")
	
	price_label.text = str(price)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and robot.gold_gems >= price:
		robot.set_current_emblem(emblem_type)
		robot.buy_product(price)


func price_hint() -> void:
	if robot:
		animation_player.play("show_price")
	else:
		animation_player.play("hide_price")

func _on_DetectionArea_body_entered(body: Robot) -> void:
	robot = body
	price_hint()

func _on_DetectionArea_body_exited(_body: Robot) -> void:
	robot = null
	price_hint()
