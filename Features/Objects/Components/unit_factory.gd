extends Node2D

const SPAWN_TIME: float = 1.0
const QUEUE_LIMIT: int = 10

@export var unit_scene: PackedScene = preload("res://Features/Objects/base_unit.tscn")

@onready var timer: Timer = $SpawnTimer
@onready var spawn_bar: ProgressBar = $SpawnBar
@onready var building: BaseBuilding = get_parent()

var spawn_offset: Vector2 = Vector2(-10, 70)
var spawn_queue: Array[BaseUnit] = []


func _process(_delta: float) -> void:
	spawn_bar.value = timer.time_left
	if not spawn_queue.is_empty() and timer.time_left == 0:
		timer.start(SPAWN_TIME)


func spawn_unit() -> bool:
	if spawn_queue.size() >= QUEUE_LIMIT:
		printerr("reached max amount of units in queue!")
		return false
	
	var unit: BaseUnit = unit_scene.instantiate()
	
	spawn_queue.push_back(unit)
	print("pushed queue: ", spawn_queue)
	
	if timer.is_stopped():
		timer.start(SPAWN_TIME)
	
	return true


func _on_spawn_timer_timeout() -> void:
	if spawn_queue.is_empty():
		return
	
	var unit: BaseUnit = spawn_queue.pop_front()
	
	get_parent().add_sibling(unit)
	unit.global_position += spawn_offset
	#TODO: change this
	# maybe the buildings should know about the map?
	unit.setup(Vector2i(unit.global_position))
	unit.move_to(building.rally_point.global_position)
	print("remaining: ", spawn_queue)
	
	if not spawn_queue.is_empty():
		timer.start(SPAWN_TIME)
