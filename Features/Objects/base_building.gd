class_name BaseBuilding extends BaseObject

const BaseBuildingScene: PackedScene = preload("res://Features/Objects/base_building.tscn")

@export var gold_cost: int

@onready var placement: Node2D = $Placement
@onready var unit_factory: Node2D = $UnitFactory


func _ready() -> void:
	set_preview(true)
	
	var group_name: StringName = object.get_group_name()
	add_to_group(group_name)
	
	health = object.max_health
	$HealthBar.max_value = object.max_health
	$HealthBar.value = health
	
	if object.selectable:
		add_to_group("Selectable", true)


func set_preview(on: bool) -> void:
	return


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
	set_preview(false)


func _on_overlap_body_entered(body: Node2D) -> void:
	placement.overlap_counter += 1
	print("overlapping with: ", body)


func _on_overlap_body_exited(body: Node2D) -> void:
	placement.overlap_counter -= 1
	print("overlap exited: ", body)


func _on_spawn_requested() -> void:
	unit_factory.queue_unit(unit_factory.unit_scene)

#region placement
signal placed

@onready var overlap_area: Area2D = $Overlap

var is_overlapping: bool = false
var overlap_counter: int = 0
var overlap_color: Color = Color(1,0,0,0.3)
var placement_color: Color = Color(1,1,1,0.3)


func _process(_delta: float) -> void:
	if not overlap_area.monitoring: return
	
	if overlap_counter > 0:
		is_overlapping = true
		modulate = overlap_color
		print("fuck you!")
	else:
		is_overlapping = false
	
	if not is_overlapping and overlap_area.monitoring:
		modulate = placement_color
#endregion
