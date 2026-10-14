class_name FormationService extends RefCounted

@export var spacing := 1


func create_formation(unit_count: int, origin: Vector2i) -> Array[Vector2i]:
	#TODO: check terrain when creating formation
	var result: Array[Vector2i] = []
	# unit_count must not count buildings
	var width: int = ceili(sqrt(unit_count))
	
	for x in range(width):
		for y in range(width):
			if result.size() >= unit_count:
				return result
			result.append(origin + Vector2i(x * spacing, y * spacing))
	
	return result
