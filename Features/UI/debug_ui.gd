extends Control

@onready var pause_button: Button = $HBox/PauseButton


func _process(_delta: float) -> void:
	if Global.game_manager.match_controller == null:
		pause_button.visible = false
	else:
		pause_button.visible = true

func _on_pause_button_pressed() -> void:
	get_tree().quit()
