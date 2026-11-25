class_name BarracksBuilding extends BaseBuilding

@onready var unit_factory: Node2D = $UnitFactory


func _ready() -> void:
	var group_name: StringName = object.get_group_name()
	add_to_group(group_name)
	
	if has_unit_factory():
		unit_factory.position = Vector2.ZERO
	
	health = object.max_health
	$HealthBar.max_value = object.max_health
	$HealthBar.value = health
	
	if object.selectable:
		add_to_group("Selectable", true)


func _on_spawn_requested() -> void:
	unit_factory.queue_unit(unit_factory.unit_scene)


func has_unit_factory() -> bool:
	return true
