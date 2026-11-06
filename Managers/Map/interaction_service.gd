class_name InteractionService extends RefCounted

var units: Array[BaseUnit]


func _on_object_targeted(object: BaseObject) -> void:
	for unit: BaseUnit in units:
		if is_instance_valid(unit) and is_instance_valid(object):
			unit.target = object
			print(unit, " targeted ", unit.target.name)


func _on_selection_changed(selection: Array[BaseObject]) -> void:
	units.clear()
	for unit in selection:
		if unit is BaseUnit:
			units.append(unit)
	print("this is from InteractionService: ", units)
