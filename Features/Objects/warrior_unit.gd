class_name WarriorUnit extends BaseUnit


func _ready() -> void:
	health = object.max_health
	$HealthBar.max_value = object.max_health
	$HealthBar.value = health
	
	var group_name: StringName = object.get_group_name()
	add_to_group(group_name)
	
	if object.selectable:
		add_to_group("Selectable", true)


static func create_unit() -> WarriorUnit:
	scene = preload("res://Features/Objects/warrior_unit.tscn")
	
	var new_unit: WarriorUnit = scene.instantiate()
	var unit_res: Resource = load("res://Features/Resources/warrior_unit_resource.tres")
	var combat_res: Resource = load("res://Features/Resources/warrior_combat_resource.tres")
	var object_res: Resource = load("res://Features/Resources/warrior_object_resource.tres")
	new_unit.unit_resource = unit_res
	new_unit.combat_resource = combat_res
	new_unit.object = object_res
	return new_unit
