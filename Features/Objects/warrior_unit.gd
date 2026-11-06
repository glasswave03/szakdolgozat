class_name WarriorUnit extends BaseUnit


func _ready() -> void:
	health = object.max_health
	$HealthBar.max_value = object.max_health
	$HealthBar.value = health
	
	var group_name: StringName = object.get_group_name()
	add_to_group(group_name)
	
	if object.selectable:
		add_to_group("Selectable", true)


static func create_unit(unit_res: Resource, combat_res: Resource, object_res: Resource) -> WarriorUnit:
	scene = preload("res://Features/Objects/warrior_unit.tscn")
	
	var new_unit: WarriorUnit = scene.instantiate()
	new_unit.unit_resource = unit_res
	new_unit.combat_resource = combat_res
	new_unit.object = object_res
	return new_unit
