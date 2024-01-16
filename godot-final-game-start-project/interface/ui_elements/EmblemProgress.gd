extends TextureProgress

const EMBLEM_ICONS : Array = [
	null,
	preload("res://icon.png"),
	preload("res://mobs/sword/sword_inactive.png"),
	preload("res://mobs/mace/mace_inactive.png"),
	preload("res://mobs/hammer/hammer_inactive.png")
]

enum Emblems {NONE, ROBOT, SWORD, MACE, HAMMER}

export(Emblems) var current_emblem := Emblems.NONE setget set_current_emblem

onready var cooldown_timer := $CooldownTimer

func _ready() -> void:
	set_current_emblem(current_emblem)
	
	Events.connect("set_emblem_cooldown", self, "_start_cooldown_timer")
	Events.connect("set_emblem_icon", self, "set_current_emblem")

func _process(delta: float) -> void:
	value = cooldown_timer.time_left

func set_current_emblem(new_emblem: int) -> void:
	current_emblem = new_emblem
	texture_under = EMBLEM_ICONS[current_emblem]
	

func _start_cooldown_timer(sec: float) -> void:
	max_value = sec
	cooldown_timer.wait_time = sec
	cooldown_timer.start()
