extends Control

const MainMenu: String = "res://Menus/main_menu.tscn"

func _on_back_button_pressed() -> void:
	#Global.game_manager.change_scene(MainMenu)
	get_tree().change_scene_to_file(MainMenu)
