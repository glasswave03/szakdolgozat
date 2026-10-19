class_name GroupManager extends Node

const MIN_GROUP := KEY_0
const MAX_GROUP := KEY_9

var groups: Dictionary[int, Array] = {}


func _init() -> void:
	for key in range(MIN_GROUP, MAX_GROUP + 1):
		groups[key] = []


func assign_group(keycode: int, objects: Array[BaseObject]) -> void:
	if not groups.has(keycode):
		return
	
	groups[keycode] = objects.filter(
		func(o: BaseObject) -> bool:
			return is_instance_valid(o)
	)


func get_group(keycode: int) -> Array[BaseObject]:
	if not groups.has(keycode) or groups[keycode].is_empty():
		return []
	
	return groups[keycode].filter(
		func(o: BaseObject) -> bool:
			return is_instance_valid(o)
	)


func clear_group(keycode: int) -> void:
	if groups.has(keycode):
		groups[keycode].clear()


func handle_group_input(event: InputEventKey, selection: SelectionManager) -> void:
	if event.keycode < MIN_GROUP or event.keycode > MAX_GROUP:
		return
	
	if event.ctrl_pressed:
		assign_group(event.keycode, selection.selected_objects)
	else:
		selection.select_objects(get_group(event.keycode))
