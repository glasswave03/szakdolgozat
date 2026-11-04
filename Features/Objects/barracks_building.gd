class_name BarracksBuilding extends BaseBuilding


func _init() -> void:
	scene = preload("res://Features/Objects/barracks_building.tscn")


func _ready() -> void:
	set_preview(true)
	
	var group_name: StringName = object.get_group_name()
	add_to_group(group_name)
	
	health = object.max_health
	$HealthBar.max_value = object.max_health
	$HealthBar.value = health
	
	if object.selectable:
		add_to_group("Selectable", true)
