extends Control


func _ready() -> void:
	visible = false


func _process(_delta: float) -> void:
	if UnitManager.has_building_in_selection():
		visible = true
	else:
		visible = false


func _on_spawn_btn_pressed() -> void:
	for building in UnitManager.get_buildings_in_selection():
		building.spawn_unit()
		


func _on_destroy_btn_pressed() -> void:
	for building in UnitManager.get_buildings_in_selection():
		building.death.emit()
