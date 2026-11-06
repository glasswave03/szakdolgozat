extends Control

const SettingsMenu: String = "res://Menus/settings_menu.tscn"

func _on_play_pressed() -> void:
	var player: Player = Player.new()
	var player2: Player = Player.new()
	if Global.game_manager.start_match([player, player2]):
		queue_free()
	else:
		printerr("Cannot start game! Maybe too few players?")


func _on_settings_pressed() -> void:
	#Global.game_manager.change_scene(SettingsMenu)
	get_tree().change_scene_to_file(SettingsMenu)


func _on_quit_pressed() -> void:
	#Global.game_manager.quit_game()
	if OS.get_name() == "Windows":
		get_tree().quit()
