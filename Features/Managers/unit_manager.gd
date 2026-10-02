extends Node

var building_scene: Resource = preload("res://Features/Objects/Buildings/base_building.tscn")
var selected_rect : Rect2:
	set(value):
		selected_rect = value
		check_unit()

var unit_selected : Array[CharacterBody2D]
var control_group_0 : Array[CharacterBody2D]
var control_group_1 : Array[CharacterBody2D]
var control_group_2 : Array[CharacterBody2D]
var control_group_3 : Array[CharacterBody2D]
var control_group_4 : Array[CharacterBody2D]
var control_group_5 : Array[CharacterBody2D]
var control_group_6 : Array[CharacterBody2D]
var control_group_7 : Array[CharacterBody2D]
var control_group_8 : Array[CharacterBody2D]
var control_group_9 : Array[CharacterBody2D]
var control_groups: Dictionary[int, Array] = {
	KEY_0: control_group_0,
	KEY_1: control_group_1,
	KEY_2: control_group_2,
	KEY_3: control_group_3,
	KEY_4: control_group_4,
	KEY_5: control_group_5,
	KEY_6: control_group_6,
	KEY_7: control_group_7,
	KEY_8: control_group_8,
	KEY_9: control_group_9
}
var formation_spacing := 1


func make_group(event: InputEvent) -> void:
	const KEY_OFFSET = 48
	
	if event.ctrl_pressed:
		control_groups[event.keycode] = unit_selected
		print("Group made #" + str(event.keycode - KEY_OFFSET) + " with " 
			+ str(unit_selected.size()) + " units")
	else:
		var group_selection: Array[CharacterBody2D] = control_groups.get(event.keycode)
		select_in(group_selection)
		unit_selected = control_groups.get(event.keycode)
		print("Group id #" + str(event.keycode - KEY_OFFSET) + " selected, number of units: " 
			+ str(unit_selected.size()))


func check_unit() -> void:
	unit_selected = []
	for unit: CharacterBody2D in get_tree().get_nodes_in_group("Selectable"):
		var unit_pos: Vector2 = unit.global_position
		#TODO: check for an area instead of a point
		if selected_rect.has_point(unit_pos):
			unit.select()
		else:
			unit.deselect()


func get_formation(tile_pos: Vector2i) -> Array[Vector2i]:
	var formation: Array[Vector2i] = []
	unit_selected = get_units_from_selection()
	var formation_size: float = ceil(sqrt(unit_selected.size()))
	var index: int = 0
	for x in range(0, formation_size + 1):
		for y in range(0, formation_size):
			if index < unit_selected.size():
				formation.append(tile_pos + Vector2i(x * formation_spacing, y * formation_spacing))
				index += 1
			else:
				break
	print(formation)
	return formation


func get_units_from_selection() -> Array:
	var new_unit_selected: Array[CharacterBody2D] = []
	clear_freed_objects()
	
	for unit: CharacterBody2D in unit_selected:
		if unit.group_type == "Unit":
			new_unit_selected.append(unit)
		else:
			unit.deselect()
	return new_unit_selected


func clear_freed_objects() -> void:
	var new_unit_selected: Array[CharacterBody2D] = []
	for unit: CharacterBody2D in unit_selected:
		if unit != null:
			new_unit_selected.append(unit)
	unit_selected = new_unit_selected


func has_building_in_selection() -> bool:
	clear_freed_objects()
	
	for unit: CharacterBody2D in unit_selected:
		if unit.group_type == "Building":
			return true
	
	return false


func get_buildings_in_selection() -> Array:
	var buildings: Array[CharacterBody2D] = []
	
	for unit: CharacterBody2D in UnitManager.unit_selected:
		if unit.group_type == "Building":
			buildings.append(unit)
	
	return buildings


func move_to_position(layer: TileMapLayer, tile_pos: Vector2i) -> void:
	clear_freed_objects()
	
	if has_building_in_selection():
		for building: CharacterBody2D in get_buildings_in_selection():
			building.move_to(snap_to_tile(layer, tile_pos))
	
	var formation := get_formation(tile_pos)
	print(formation)
	
	for i in range(unit_selected.size()):
		unit_selected[i].move_to(snap_to_tile(layer, formation[i]))
 

func select_in(group: Array[CharacterBody2D]) -> void:
	for unit: CharacterBody2D in get_tree().get_nodes_in_group("Selectable"):
		if unit in group:
			unit.select()
		else:
			unit.deselect()


func spawn_building(layer: TileMapLayer, spawn_pos: Vector2) -> BaseBuilding:
	var new_building: BaseBuilding = building_scene.instantiate()
	new_building.position = snap_to_tile(layer, spawn_pos)
	new_building.modulate = new_building.placement_color
	add_child(new_building)
	new_building.collision.disabled = true
	
	return new_building


func snap_to_tile(layer: TileMapLayer, pos: Vector2) -> Vector2i:
	return layer.map_to_local(Vector2i(pos))


func deselect_units() -> void:
	for unit: CharacterBody2D in unit_selected:
		unit.deselect()
	unit_selected.clear()
