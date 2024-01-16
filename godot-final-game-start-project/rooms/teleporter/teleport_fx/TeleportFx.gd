extends AnimatedSprite

onready var _particle := $Particle
onready var _timer := $Timer


func _ready():
	playing = true
	_timer.connect("timeout", self, "queue_free")


func _on_animation_finished():
	_particle.emitting = false
	_timer.start()
