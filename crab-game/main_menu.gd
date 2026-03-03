extends Control

func _ready():
	$Credits.hide()

# START BUTTON
func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/battle.tscn")
func _on_start_button_mouse_entered() -> void:
	$hover_sfx.play()

# CREDITS BUTTON
func _on_credits_button_pressed() -> void:
	$Credits.show()
func _on_credits_button_mouse_entered() -> void:
	$hover_sfx.play()

# EXIT CREDITS
func _on_exit_credits_pressed() -> void:
	$Credits.hide()
