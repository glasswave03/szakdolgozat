class_name PeasantUnit extends BaseUnit


func _ready() -> void:
	health = object.max_health
	$HealthBar.max_value = object.max_health
	$HealthBar.value = health
	
	var group_name: StringName = object.get_group_name()
	add_to_group(group_name)
	
	if object.selectable:
		add_to_group("Selectable", true)


static func create_unit() -> PeasantUnit:
	const SCENE = preload("res://Features/Objects/Units/peasant_unit.tscn")
	
	var new_unit: PeasantUnit = SCENE.instantiate()
	var unit_res: Resource = load("res://Features/Resources/peasant_unit_resource.tres")
	var combat_res: Resource = load("res://Features/Resources/peasant_combat_resource.tres")
	var object_res: Resource = load("res://Features/Resources/peasant_object_resource.tres")
	new_unit.unit_resource = unit_res
	new_unit.combat_resource = combat_res
	new_unit.object = object_res
	return new_unit
