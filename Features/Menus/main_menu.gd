extends Control



func _on_play_pressed() -> void:
	var player: Player = Player.new()
	Global.game_manager.start_match([player])


func _on_settings_pressed() -> void:
	Global.game_manager.change_scene(settings_menu)


func _on_quit_pressed() -> void:
	Global.game_manager.quit_game()
