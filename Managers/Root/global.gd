extends Node

const save_location = "user://save.json"
const SettingsPath = "user://settings.json"

var game_manager: GameManager
var settings_data: Dictionary = {}
var contents_to_save: Dictionary = {
	"highscore": 0
}


func _ready() -> void:
	_load_settings_into(settings_data)


func _save() -> void:
	var file := FileAccess.open(save_location, FileAccess.WRITE)
	file.store_var(contents_to_save.duplicate())
	file.close()


func _load() -> void:
	var file := FileAccess.open(save_location, FileAccess.READ)
	if file == null:
		printerr("File could not be opened: ", FileAccess.get_open_error())
		return
	
	var data: Variant = file.get_var()
	file.close()
	
	var save_data: Variant = data.duplicate()
	contents_to_save.highscore = save_data.highscore


func _save_settings(unsaved_settings: Dictionary) -> void:
	var file := FileAccess.open(SettingsPath, FileAccess.WRITE)
	file.store_var(unsaved_settings.duplicate())
	file.close()


func _load_settings_into(settings: Dictionary) -> void:
	var file := FileAccess.open(SettingsPath, FileAccess.READ)
	
	if file == null:
		printerr("File could not be opened: ", FileAccess.get_open_error())
		return
	
	var data: Dictionary = file.get_var()
	file.close()
	
	var save_data: Dictionary = data.duplicate()
	if not save_data.is_empty():
		settings.assign(save_data)
