class_name SelectionManager extends Node

signal changed(objects: Array[BaseObject])

var selected_rect : Rect2:
	set(value):
		selected_rect = value
		check_unit()

var selected_objects : Array[BaseObject]


func check_unit() -> void:
	selected_objects = []
	for object: BaseObject in get_tree().get_nodes_in_group("Selectable"):
		var object_pos: Vector2 = object.global_position
		#TODO: check for an area instead of a point
		if selected_rect.has_point(object_pos):
			object.select()
		else:
			object.deselect()


func get_units() -> Array[BaseUnit]:
	var new_selected_objects: Array[BaseUnit] = []
	clear_freed_objects()
	
	for unit: BaseUnit in selected_objects:
		if unit.group_type == "Unit":
			new_selected_objects.append(unit)
		else:
			unit.deselect()
	
	return new_selected_objects


func get_buildings() -> Array[BaseBuilding]:
	var buildings: Array[BaseBuilding] = []
	
	for unit: BaseBuilding in selected_objects:
		if unit.group_type == "Building":
			buildings.append(unit)
	
	return buildings


func clear_freed_objects() -> void:
	var new_selected_objects: Array[BaseObject] = []
	for unit: BaseObject in selected_objects:
		if unit != null and is_instance_valid(unit):
			new_selected_objects.append(unit)
	selected_objects = new_selected_objects


func has_building_in_selection() -> bool:
	clear_freed_objects()
	
	for unit: BaseBuilding in selected_objects:
		if unit.group_type == "Building":
			return true
	
	return false


func clear_selection() -> void:
	for object: BaseObject in selected_objects:
		object.deselect()
	
	selected_objects.clear()


func _on_object_clicked(object: BaseObject, event: InputEventMouseButton) -> void:
	if event.double_click:
		select_group(get_tree().get_nodes_in_group(object.group_type))
	else:
		if event.ctrl_pressed:
			add_to_selection(object)
		else:
			select_single(object)
	
	changed.emit(selected_objects)
	print("object clicked!")


func add_to_selection(object: BaseObject) -> void:
	object.select()
	selected_objects.append(object)


func select_group(group: Array[Node]) -> void:
	clear_selection()
	for object: BaseObject in group:
		add_to_selection(object)


func select_single(object: BaseObject) -> void:
	clear_selection()
	
	add_to_selection(object)
	
	print("single object selected: ", selected_objects)


func select_objects(objects: Array[BaseObject]) -> void:
	clear_selection()
	
	for object: BaseObject in objects:
		add_to_selection(object)
	
	#print("objects selected: ", selected_objects)


func _on_dragbox_released(rect: Rect2) -> void:
	var objects: Array[BaseObject] = []
	
	selected_rect = rect
	
	for object: BaseObject in get_tree().get_nodes_in_group("Selectable"):
		if object.select_mode == true:
			objects.append(object)
	
	select_objects(objects)
