class_name MovementService extends RefCounted

var formation_service: FormationService


func _init(service: FormationService) -> void:
	formation_service = service


func move_selected(objects: Array[BaseObject], clicked_tile: Vector2i) -> void:
	#selection_manager.clear_freed_objects()
	#
	#if selection_manager.has_building_in_selection():
		#for building: BaseObject in selection_manager.get_buildings_in_selection():
			#building.move_to(clicked_tile)
	#
	#var formation := formation_service.create_formation(selection_manager.get_units().size(), clicked_tile)
	#
	#for i in range(selection_manager.get_units().size()):
		#selection_manager.unit_selected[i].move_to(formation[i])
	
	########################################################################
	#TODO: check correctness of code below
	# AI code:
	
	var units: Array[BaseUnit] = []
	var buildings: Array[BaseBuilding] = []
	
	for object: BaseObject in objects:
		if object is BaseUnit:
			units.append(object)
		elif object is BaseBuilding:
			buildings.append(object)
	
	for building: BaseBuilding in buildings:
		building.move_to(clicked_tile)
	
	var positions := formation_service.create_formation(
		units.size(),
		clicked_tile
	)
	
	for index in range(min(units.size(), positions.size())):
		units[index].move_to(positions[index])
