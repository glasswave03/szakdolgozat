class_name ObjectResource extends Resource

@export var name: String
@export var max_health: float
@export var group: Groups
@export var selectable: bool = true
@export var selection_size: float
@export var select_mode: bool = false

enum Groups {
	OBJECT,
	UNIT,
	BUILDING,
	
}

func get_group_name() -> StringName:
	match group:
		0:
			return StringName("Object")
		1:
			return StringName("Unit")
		2:
			return StringName("Building")
		_:
			return StringName("Unknown")
