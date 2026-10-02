extends Control

@onready var building_ui: Control = $BuildingUI


func _ready() -> void:
	building_ui.visible = false


func _process(_delta: float) -> void:
	if UnitManager.has_building_in_selection():
		building_ui.visible = true
	else:
		building_ui.visible = false


func _on_spawn_btn_pressed() -> void:
	for building: BaseBuilding in UnitManager.get_buildings_in_selection():
		building.spawn_unit()
		#TODO: building.change_state(spawn(BaseUnit)) or something


func _on_destroy_btn_pressed() -> void:
	for building: BaseBuilding in UnitManager.get_buildings_in_selection():
		building.death.emit()
