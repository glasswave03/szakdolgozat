class_name SelectionManager extends Node

var selected_rect : Rect2:
	set(value):
		selected_rect = value
		check_unit()

var selected_objects : Array[BaseObject]


func check_unit() -> void:
	selected_objects = []
	for unit: CharacterBody2D in get_tree().get_nodes_in_group("Selectable"):
		var unit_pos: Vector2 = unit.global_position
		#TODO: check for an area instead of a point
		if selected_rect.has_point(unit_pos):
			unit.select()
		else:
			unit.deselect()


func get_units() -> Array[BaseUnit]:
	var new_selected_objects: Array[BaseUnit] = []
	clear_freed_objects()
	
	for unit: CharacterBody2D in selected_objects:
		if unit.group_type == "Unit":
			new_selected_objects.append(unit)
		else:
			unit.deselect()
	return new_selected_objects


func clear_freed_objects() -> void:
	var new_selected_objects: Array[BaseObject] = []
	for unit: BaseObject in selected_objects:
		if unit != null:
			new_selected_objects.append(unit)
	selected_objects = new_selected_objects


func has_building_in_selection() -> bool:
	clear_freed_objects()
	
	for unit: BaseBuilding in selected_objects:
		if unit.group_type == "Building":
			return true
	
	return false


func get_buildings() -> Array[BaseBuilding]:
	var buildings: Array[BaseBuilding] = []
	
	for unit: BaseBuilding in selected_objects:
		if unit.group_type == "Building":
			buildings.append(unit)
	
	return buildings


func select_objects(objects: Array[BaseObject]) -> void:
	pass
