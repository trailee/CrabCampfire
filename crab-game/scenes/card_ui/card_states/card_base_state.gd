extends CardState

func enter() -> void:
	if not card_ui.is_node_ready():
		await card_ui.ready
