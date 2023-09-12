extends Camera2D

const shake_strength : float = 10.0
const shake_duration : float = 0.25

@onready var timer = $ShakeTimer


func _process(delta):
	if not timer.is_stopped():
		setOffset()


func shake():
	timer.start(shake_duration)


func setOffset():
	offset = Vector2(randf_range(-1, 1) * shake_strength, randf_range(-1, 1) * shake_strength)


func resetCamera() -> void:
	offset = Vector2.ZERO


func _on_shake_timer_timeout():
	resetCamera()
