extends Control

const MainMenu: String = "res://Menus/main_menu.tscn"

func _on_back_button_pressed() -> void:
	#Global.game_manager.change_scene(MainMenu)
	Global.game_manager.change_scene(MainMenu)


func _on_mute_toggled(toggled_on: bool) -> void:
	pass # Replace with function body.


func _on_music_slider_value_changed(value: float) -> void:
	pass # Replace with function body.


func _on_sfx_slider_value_changed(value: float) -> void:
	pass # Replace with function body.


func _on_save_button_pressed() -> void:
	pass # Replace with function body.
