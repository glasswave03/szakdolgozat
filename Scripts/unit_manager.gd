extends Node

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

func make_group(event):
	const KEY_OFFSET = 48
	if event is not InputEventKey:
		return
	if event.pressed and event.keycode in control_groups:
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
	for unit in get_tree().get_nodes_in_group("Unit"):
		if selected_rect.has_point(unit.global_position):
			unit.select()
			unit_selected.append(unit)
		else:
			unit.deselect()
	print(unit_selected)
 
func get_formation(tile_pos):
	var formation = []  
	var unit_count = unit_selected.size()
	var formation_size = ceil(sqrt(unit_count))
	var index = 0
	for x in range(-formation_size / 2, formation_size / 2 + 1):
		for y in range(-formation_size / 2, formation_size / 2 + 1):
			if index < unit_count:
				formation.append(tile_pos + Vector2i(x, y))
				index += 1
			else:
				break
				
	return formation
 
func move_to_position(layer : TileMapLayer, tile_pos):
	var formation = get_formation(tile_pos)
	for i in range(unit_selected.size()):
		unit_selected[i].move_to(layer.map_to_local(formation[i]))
 
func select_in(group):
	for unit in get_tree().get_nodes_in_group("Unit"):
		if unit in group:
			unit.select()
		else:
			unit.deselect()
