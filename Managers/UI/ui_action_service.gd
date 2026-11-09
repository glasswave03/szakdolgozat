class_name UIActionService extends RefCounted


func spawn_units_at_selected_buildings(buildings: Array[BaseBuilding]) -> void:
	for building: BaseBuilding in buildings:
		if not is_instance_valid(building):
			printerr("Building not found!")
			continue
		if building.has_unit_factory():
			building.unit_factory.queue_unit()


func destroy_selected_buildings(buildings: Array[BaseBuilding]) -> void:
	for building: BaseBuilding in buildings:
		if not is_instance_valid(building):
			printerr("Building not found!")
			return
		building.health = 0.0
