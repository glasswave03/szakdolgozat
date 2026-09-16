extends Node

var building_scene = preload("res://Scenes/Buildings/base_building.tscn")
var selected_rect : Rect2:
	set(value):
		selected_rect = value
		check_unit()

var unit_selected : Array
var control_group_0 : Array
var control_group_1 : Array
var control_group_2 : Array
var control_group_3 : Array
var control_group_4 : Array
var control_group_5 : Array
var control_group_6 : Array
var control_group_7 : Array
var control_group_8 : Array
var control_group_9 : Array
var control_groups: Dictionary = {
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
var formation_spacing := 2


func make_group(event):
	const KEY_OFFSET = 48
	
	if event.ctrl_pressed:
		control_groups[event.keycode] = unit_selected
		print("Group made #" + str(event.keycode - KEY_OFFSET) + " with " 
			+ str(unit_selected.size()) + " units")
	else:
		select_in(control_groups.get(event.keycode))
		unit_selected = control_groups.get(event.keycode)
		print("Group id #" + str(event.keycode - KEY_OFFSET) + " selected, number of units: " 
			+ str(unit_selected.size()))


func check_unit():
	unit_selected = []
	for unit in get_tree().get_nodes_in_group("Selectable"):
		if selected_rect.has_point(unit.global_position):
			unit.select()
			unit_selected.append(unit)
		else:
			unit.deselect()


func get_formation(tile_pos):
	var formation = []
	unit_selected = get_units_only()
	var formation_size = ceil(sqrt(unit_selected.size()))
	var index = 0
	for x in range(0, formation_size + 1):
		for y in range(0, formation_size):
			if index < unit_selected.size():
				formation.append(tile_pos + Vector2i(x * formation_spacing, y * formation_spacing))
				index += 1
			else:
				break
	
	return formation


func get_units_only():
	var new_unit_selected = []
	
	for unit in unit_selected:
		if unit.group_type == "Unit":
			new_unit_selected.append(unit)
		else:
			unit.deselect()
	return new_unit_selected


func clear_freed_objects():
	var new_unit_selected = []
	for unit in unit_selected:
		if unit != null:
			new_unit_selected.append(unit)
	unit_selected = new_unit_selected


func has_building_in_selection() -> bool:
	clear_freed_objects()
	
	for unit in unit_selected:
		if unit.group_type == "Building":
			return true
	
	return false


func get_buildings_in_selection() -> Array:
	var buildings = []
	
	for unit in UnitManager.unit_selected:
		if unit.group_type == "Building":
			buildings.append(unit)
	
	return buildings


func move_to_position(layer : TileMapLayer, tile_pos):
	clear_freed_objects()
	
	if has_building_in_selection():
		for building in get_buildings_in_selection():
			building.move_to(snap_to_tile(layer, tile_pos))
	
	var formation = get_formation(tile_pos)
	
	for i in range(unit_selected.size()):
		unit_selected[i].move_to(snap_to_tile(layer, formation[i]))
 

func select_in(group):
	for unit in get_tree().get_nodes_in_group("Selectable"):
		if unit in group:
			unit.select()
		else:
			unit.deselect()


func spawn_building(layer: TileMapLayer, spawn_pos):
	var new_building = building_scene.instantiate()
	new_building.position = snap_to_tile(layer, spawn_pos)
	new_building.modulate = new_building.placement_color
	add_child(new_building)
	new_building.collision.disabled = true
	
	return new_building


func snap_to_tile(layer: TileMapLayer, pos):
	return layer.map_to_local(Vector2i(pos))
