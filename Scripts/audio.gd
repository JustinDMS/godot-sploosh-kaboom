extends AudioStreamPlayer

@onready var sploosh : AudioStreamWAV = load("res://Assets/sploosh.wav")
@onready var kaboom : AudioStreamWAV = load("res://Assets/kaboom.wav")


func playHit():
	stream = kaboom
	play()


func playMiss():
	stream = sploosh
	play()
