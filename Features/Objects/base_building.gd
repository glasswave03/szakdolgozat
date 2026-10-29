class_name BaseBuilding extends BaseObject

@export var gold_cost: int

@onready var placement: Node2D = $Placement
@onready var unit_factory: Node2D = $UnitFactory


func _ready() -> void:
	var group_name: StringName = object.get_group_name()
	add_to_group(group_name)
	
	health = object.max_health
	$HealthBar.max_value = object.max_health
	$HealthBar.value = health
	
	if object.selectable:
		add_to_group("Selectable", true)


func _on_damaged() -> void:
	$HealthBar.value = health


func destroy() -> void:
	#TODO: disable interaction and await animations
	death.emit()


func _on_death() -> void:
	deselect()
	call_deferred("queue_free")
	print("building destroyed")


func _on_placed() -> void:
	placement.overlap_area.monitoring = false
	modulate = Color.WHITE


func _on_overlap_body_entered(body: Node2D) -> void:
	placement.overlap_counter += 1
	print("overlapping with: ", body)


func _on_overlap_body_exited(body: Node2D) -> void:
	placement.overlap_counter -= 1
	print("overlap exited: ", body)


func _on_spawn_requested() -> void:
	unit_factory.queue_unit(unit_factory.unit_scene)
