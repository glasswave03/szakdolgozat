@abstract
class_name BaseUnitFactory extends Node2D

signal unit_spawned(unit: BaseUnit, rally_pos: Vector2)

const QUEUE_LIMIT: int = 5

var spawn_time: float = 1.0

@onready var timer: Timer = $SpawnTimer
@onready var spawn_bar: ProgressBar = $SpawnBar
@onready var building: BaseBuilding = get_parent()
@onready var rally_point: Sprite2D = $RallyPoint

var spawn_offset: Vector2 = Vector2(-10, 70)
var spawn_queue: Array[BaseUnit] = []


func _ready() -> void:
	rally_point.visible = false


func _process(_delta: float) -> void:
	spawn_bar.max_value = spawn_time
	spawn_bar.value = timer.time_left
	if not spawn_queue.is_empty() and timer.is_stopped():
		timer.start(spawn_time)
	
	if building.select_mode:
		rally_point.visible = true
	else:
		rally_point.visible = false


@abstract func queue_unit() -> void


func _on_spawn_timer_timeout() -> void:
	if spawn_queue.is_empty():
		return
	
	var unit: Area2D = spawn_queue.pop_front()
	
	building.add_sibling(unit)
	unit.global_position += building.global_position + spawn_offset
	var map_controller := get_parent().get_parent().get_parent()
	
	unit.setup(Vector2i(unit.global_position), map_controller)
	unit.team = building.team
	#TODO: make the unit do something like below
	#unit.move_to(building.rally_point.global_position)
	#TODO: connect this to movement_service
	unit_spawned.emit(unit, rally_point.global_position)
	print("remaining: ", spawn_queue)
	
	if not spawn_queue.is_empty():
		timer.start(spawn_time)


func set_rally_point(pos: Vector2) -> void:
	rally_point.global_position = pos
