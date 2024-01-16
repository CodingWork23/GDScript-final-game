## Takes care of showing the UI. Should be always present. Uses the global Events
## autoload to know when to update
extends Control

var _score := 0 setget _set_score

onready var _health_bar := $TopBar/VBoxContainer/HealthBar
onready var _heal_kit := $TopBar/VBoxContainer/HealKit
onready var _score_label := $TopBar/HBoxContainer/ScoreLabel

func _ready() -> void:
	_set_score(0)
	
	Events.connect("player_health_changed", self, "_on_player_health_changed")
	Events.connect("player_heal_kit_changed", self, "_on_player_heal_kit_changed")
	#Events.connect("mob_died", self, "_on_Events_mob_dies")
	Events.connect("set_max_health", self, "_set_player_max_health")
	Events.connect("set_gold_gems", self, "_set_score")
	

func _set_player_max_health(max_health: int) -> void:
	_health_bar.max_health = max_health
	#_on_player_health_changed(max_health)

func _on_player_health_changed(new_health: int) -> void:
	_health_bar.health = new_health

func _on_player_heal_kit_changed(new_heal_kit: int) -> void:
	_heal_kit.heal_kit = new_heal_kit

func _set_score(new_score: int) -> void:
	_score = new_score
	_score_label.text = str(_score).pad_zeros(4)

#func _on_Events_mob_dies(mob_score_value: int) -> void:
#	_set_score(_score + mob_score_value)
