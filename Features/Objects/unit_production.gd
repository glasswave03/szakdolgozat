extends Node2D

const SPAWN_TIME: float = 1.0
const QUEUE_LIMIT: int = 10

@export var unit_scene: PackedScene = preload("res://Features/Objects/base_unit.tscn")

@onready var timer: Timer = $SpawnTimer
@onready var spawn_bar: ProgressBar = $SpawnBar

var spawn_offset: Vector2 = Vector2(-10, 70)
var spawn_queue: Array[CharacterBody2D] = []
var parent: BaseBuilding = get_parent()


func _process(_delta: float) -> void:
	spawn_bar.value = timer.time_left
	if not spawn_queue.is_empty() and timer.time_left == 0:
		timer.start(SPAWN_TIME)


func spawn_unit() -> void:
	if spawn_queue.size() > QUEUE_LIMIT:
		printerr("reached max amount of units in queue!")
		return
	var unit: BaseUnit = unit_scene.instantiate()
	spawn_queue.push_back(unit)
	print("pushed queue: ", spawn_queue)
	unit.position = position + spawn_offset
	unit.setup(parent.grid, parent.tilemap)
	await timer.timeout


func _on_spawn_timer_timeout() -> void:
	var unit: CharacterBody2D = spawn_queue.pop_front()
	
	add_sibling(unit)
	unit.move_to(parent.rally_point.global_position)
	print("popped queue, remaining: ", spawn_queue)
