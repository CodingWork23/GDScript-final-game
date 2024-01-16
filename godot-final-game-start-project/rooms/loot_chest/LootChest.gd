extends LootChest

onready var animation_player := $AnimationPlayer


func _ready() -> void:
	animation_player.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")

func open_chest() -> void:
	animation_player.play("open")

func loot_chest() -> void:
	.loot_chest()
	chest_full.show()

func _on_AnimationPlayer_animation_finished(animation: String) -> void:
	if animation == "open":
		loot_chest()
		
