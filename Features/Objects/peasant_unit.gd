class_name PeasantUnit extends BaseUnit

const PeasantScene: PackedScene = preload("res://Features/Objects/peasant_unit.tscn")


func _ready() -> void:
	health = object.max_health
	$HealthBar.max_value = object.max_health
	$HealthBar.value = health
	
	var group_name: StringName = object.get_group_name()
	add_to_group(group_name)
	
	if object.selectable:
		add_to_group("Selectable", true)


static func create_unit(unit_res: Resource, object_res: Resource) -> PeasantUnit:
	var new_unit: PeasantUnit = PeasantScene.instantiate()
	new_unit.unit_resource = unit_res
	new_unit.object = object_res
	return new_unit
