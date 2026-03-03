extends Control

signal textbox_closed

@export var enemy: Resource = null
@export var next_enemy_scene: PackedScene

var current_player_health = 0
var current_enemy_health = 0
var is_defending = false

func _ready():
	set_health($EnemyContainer/ProgressBar, enemy.health, enemy.health)
	set_health($"Player Panel/PlayerData/ProgressBar", State.current_health, State.max_health)
	$EnemyContainer/Enemy.texture = enemy.texture
	
	current_player_health = State.current_health
	current_enemy_health = enemy.health
	
	$Textbox.hide()
	$ActionsPanel.hide()
	
	display_text("You enter a cave and somehow find yourself in front of a crab.")
	await textbox_closed
	$ActionsPanel.show()

func set_health(progress_bar: ProgressBar, health: int, max_health: int):
	progress_bar.value = health
	progress_bar.max_value = max_health
	progress_bar.get_node("Label").text = "HP: %d/%d" % [health, max_health]

func _input(event):
	if $Textbox.visible:
		if Input.is_action_just_pressed("ui_accept"):
			$Textbox.hide()
			textbox_closed.emit()
		elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			$Textbox.hide()
			textbox_closed.emit()

func display_text(text):
	$ActionsPanel.hide()
	$Textbox.show()
	$Textbox/Label.text = text

func enemy_turn():
	display_text("%s pinches you!" % enemy.name)
	await textbox_closed
	
	if is_defending:
		is_defending = false
		display_text("Your defense actually worked!")
		await textbox_closed
	else:
		current_player_health = max(0, current_player_health - enemy.damage)
		set_health($"Player Panel/PlayerData/ProgressBar", current_player_health, State.max_health)
		$AnimationPlayer.play("player_damaged")
		display_text("%s dealt %d damage!" % [enemy.name, enemy.damage])
		await textbox_closed
	$ActionsPanel.show()

func _on_attack_pressed():
	display_text("You flail your arms around!")
	await textbox_closed
	
	current_enemy_health = max(0, current_enemy_health - State.damage)
	set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)

	$AnimationPlayer.play("enemy_damaged")
	await $AnimationPlayer.animation_finished
	
	display_text("You dealt %d damage!" % State.damage)
	await textbox_closed
	
	if current_enemy_health == 0:
		display_text("%s was defeated!" % enemy.name)
		await textbox_closed
		
		await get_tree().create_timer(0.25).timeout
		# Load next enemy battle instead of quitting
		if next_enemy_scene:
			get_tree().change_scene_to_packed(next_enemy_scene)
		else:
			get_tree().quit()

	enemy_turn()
func _on_Defend_pressed():
	is_defending = true
	
	display_text("You shield your head like a coward!")
	await textbox_closed
	
	await get_tree().create_timer(0.25).timeout
	
	enemy_turn() 
