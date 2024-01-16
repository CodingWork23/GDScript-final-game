extends Label

export(int) var wait_time := 300

onready var _timer := $Timer

func _ready() -> void:
	_timer.wait_time = wait_time
	
	_timer.connect("timeout", self, "_on_Timer_timeout")
	Events.connect("set_current_camera", self, "_start_timer")

func _process(delta: float) -> void:
	text = get_remaining_time()

func _start_timer(state: bool) -> void:
	if state:
		_timer.start()
	else:
		_timer.stop()

func _on_Timer_timeout() -> void:
	Events.emit_signal("end_game")

func get_remaining_time() -> String:
	var hours := int(_timer.time_left / 60)
	var minuts : int = int(_timer.time_left) % 60
	
	return str(hours).pad_zeros(2) + " : " + str(minuts).pad_zeros(2)
