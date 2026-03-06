extends CanvasLayer

func _ready() -> void:
	hide()

func _on_attack_pressed() -> void:
	show()

func _on_endturn_button_pressed() -> void:
	hide()
