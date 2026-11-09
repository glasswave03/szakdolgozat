class_name HouseBuilding extends BaseBuilding


func _ready() -> void:
	var group_name: StringName = object.get_group_name()
	add_to_group(group_name)
	
	health = object.max_health
	$HealthBar.max_value = object.max_health
	$HealthBar.value = health
	
	if object.selectable:
		add_to_group("Selectable", true)
