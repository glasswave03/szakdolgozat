extends Control
class_name Settings

const MainMenu: String = "res://Menus/main_menu.tscn"


var unsaved_settings: Dictionary = {}

@onready var popup: Popup = $Popup
@onready var mute_check: CheckButton = $MainBody/SettingsGrid/MuteCheck
@onready var fullscreen_check: CheckBox = $MainBody/SettingsGrid/FullscreenCheck
@onready var resolutions: OptionButton = $MainBody/SettingsGrid/ResolutionOptions
@onready var music_slider: HSlider = $MainBody/SettingsGrid/MusicSlider
@onready var sfx_slider: HSlider = $MainBody/SettingsGrid/SFXSlider


func _ready() -> void:
	Global._load_settings_into(Global.settings_data)
	Global._load_settings_into(unsaved_settings)
	
	# settings_data is loaded into unsaved_settings and sets every item
	initialize_settings()


func _on_back_button_pressed() -> void:
	if Global.settings_data == unsaved_settings:
		_set_settings()
		_go_to_main_menu()
	else:
		popup.size = DisplayServer.window_get_size() / Vector2i(3,3)
		popup.show()



func _on_mute_toggled(toggled_on: bool) -> void:
	set_mute(toggled_on)
	unsaved_settings.set("mute", toggled_on)


func _on_music_slider_value_changed(value: float) -> void:
	set_music_volume(value)
	unsaved_settings.set("music", value)


func _on_sfx_slider_value_changed(value: float) -> void:
	set_sfx_volume(value)
	unsaved_settings.set("sfx", value)


func _on_resolution_options_item_selected(index: int) -> void:
	set_resolution(index)
	unsaved_settings.set("resolution", index)


func _on_fullscreen_check_toggled(toggled_on: bool) -> void:
	var index: int = unsaved_settings.get("resolution")
	
	# instantly toggles whether resolutions are disabled or not
	if toggled_on:
		resolutions.disabled = true
		resolutions.text = "Fullscreen enabled"
	else:
		resolutions.disabled = false
		resolutions.text = resolutions.get_item_text(index)
	
	set_fullscreen(toggled_on)
	
	unsaved_settings.set("fullscreen", toggled_on)


func _on_save_button_pressed() -> void:
	Global._save_settings(unsaved_settings)
	_go_to_main_menu()


func _on_discard_button_pressed() -> void:
	_set_settings()
	_go_to_main_menu()


func _on_dont_button_pressed() -> void:
	popup.hide()


func _go_to_main_menu() -> void:
	unsaved_settings.clear()
	
	Global.game_manager.change_scene(MainMenu)


func initialize_settings() -> void:
	mute_check.button_pressed = unsaved_settings.get("mute")
	music_slider.value = unsaved_settings.get("music")
	sfx_slider.value = unsaved_settings.get("sfx")
	resolutions.selected = unsaved_settings.get("resolution")
	fullscreen_check.button_pressed = unsaved_settings.get("fullscreen")


static func _set_settings() -> void:
	var mute: bool = Global.settings_data.get("mute")
	var music_vol: float = Global.settings_data.get("music")
	var sfx_vol: float = Global.settings_data.get("sfx")
	var resolution: int = Global.settings_data.get("resolution")
	var fullscreen: bool = Global.settings_data.get("fullscreen")
	
	set_mute(mute)
	set_music_volume(music_vol)
	set_sfx_volume(sfx_vol)
	set_resolution(resolution)
	set_fullscreen(fullscreen)


static func set_mute(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0, toggled_on)


static func set_music_volume(value: float) -> void:
	var music_bus := 2
	AudioServer.set_bus_volume_db(music_bus, value)


static func set_sfx_volume(value: float) -> void:
	var SFX_bus := 1
	AudioServer.set_bus_volume_db(SFX_bus, value)


static func set_resolution(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1280, 720))
		1:
			DisplayServer.window_set_size(Vector2i(1600, 900))
		2:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
		3:
			DisplayServer.window_set_size(Vector2i(1920, 1200))


static func set_fullscreen(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
