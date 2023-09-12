extends Control

@onready var label = $Panel/CenterContainer/VBoxContainer/Label


func setLabelText(is_game_won : bool) -> void:
	if is_game_won:
		label.set_text("You won!")
		return
	label.set_text("Game over!")


func _on_play_pressed():
	get_tree().reload_current_scene()


func _on_quit_pressed():
	get_tree().quit()
