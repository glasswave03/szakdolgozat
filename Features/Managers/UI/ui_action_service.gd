class_name UIActionService extends RefCounted


func spawn_units_at_selected_buildings(buildings: Array[BaseBuilding]) -> void:
	for building: BaseBuilding in buildings:
		building.unit_factory.queue_unit()
	print("spawn unit button clicked!")
	pass


func destroy_selected_buildings(buildings: Array[BaseBuilding]) -> void:
	for building: BaseBuilding in buildings:
		building.health = 0.0
	print("destroy building button clicked!")
	pass
