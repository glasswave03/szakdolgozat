extends Control


func _ready() -> void:
	#visible = false
	pass


func _on_spawn_btn_pressed() -> void:
	for building in UnitManager.unit_selected:
		if building.group_type == "Building":
			building.spawn_unit()
		


func _on_destroy_btn_pressed() -> void:
	for building in UnitManager.unit_selected:
		if building.group_type == "Building":
			building.death.emit()


func _on_set_btn_pressed() -> void:
	pass # Replace with function body.
