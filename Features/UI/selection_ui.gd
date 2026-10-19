extends Control

@onready var building_ui: Control = $BuildingUI

var selection: SelectionManager


func _ready() -> void:
	building_ui.visible = false


func setup(_selection: SelectionManager) -> void:
	selection = _selection
	
	selection.selection_changed.connect(_on_selection_changed)


func _on_spawn_btn_pressed() -> void:
	for building: BaseBuilding in selection.get_buildings():
		building.spawn_unit()


func _on_destroy_btn_pressed() -> void:
	for building: BaseBuilding in selection.get_buildings():
		building.death.emit()


func _on_selection_changed(objects: Array[BaseObject]) -> void:
	var has_building := false
	
	for o: BaseObject in objects:
		if o is BaseBuilding:
			has_building = true
			break
	
	building_ui.visible = has_building
