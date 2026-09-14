extends Control

const SPAWN_TIME := 1.0


func _ready() -> void:
	#visible = false
	pass


func _on_spawn_btn_pressed() -> void:
	for unit in UnitManager.unit_selected:
		if unit.group_type == "Building":
			await get_tree().create_timer(SPAWN_TIME).timeout
			unit.spawn_unit()


func _on_destroy_btn_pressed() -> void:
	for unit in UnitManager.unit_selected:
		if unit.group_type == "Building":
			unit.death.emit()


func _on_set_btn_pressed() -> void:
	pass # Replace with function body.
