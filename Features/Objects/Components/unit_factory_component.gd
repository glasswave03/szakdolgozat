extends Node2D

signal unit_spawned(unit: BaseUnit, rally_pos: Vector2)

const SPAWN_TIME: float = 1.0
const QUEUE_LIMIT: int = 10

const BaseUnitScene: PackedScene = preload("res://Features/Objects/base_unit.tscn")

@onready var timer: Timer = $SpawnTimer
@onready var spawn_bar: ProgressBar = $SpawnBar
@onready var building: BaseBuilding = get_parent()
@onready var rally_point: Sprite2D = $RallyPoint

var spawn_offset: Vector2 = Vector2(-10, 70)
var spawn_queue: Array[BaseUnit] = []


func _ready() -> void:
	rally_point.visible = true


func _process(_delta: float) -> void:
	spawn_bar.value = timer.time_left
	if not spawn_queue.is_empty() and timer.is_stopped():
		timer.start(SPAWN_TIME)
	if building.select_mode:
		rally_point.visible = true
	else:
		rally_point.visible = false


func queue_unit() -> void:
	if spawn_queue.size() >= QUEUE_LIMIT:
		printerr("reached max amount of units in queue!")
		return
	
	var unit: PeasantUnit = create_peasant()
	
	spawn_queue.push_back(unit)
	print("queued unit")
	
	if timer.is_stopped():
		timer.start(SPAWN_TIME)


func create_warrior() -> WarriorUnit:
	var unit_res: Resource = load("res://Features/Resources/warrior_unit_resource.tres")
	var combat_res: Resource = load("res://Features/Resources/warrior_combat_resource.tres")
	var object_res: Resource = load("res://Features/Resources/warrior_object_resource.tres")
	var new_warrior: WarriorUnit = WarriorUnit.create_unit(unit_res, combat_res, object_res)
	return new_warrior


func create_peasant() -> PeasantUnit:
	var unit_res: Resource = load("res://Features/Resources/peasant_unit_resource.tres")
	var combat_res: Resource = load("res://Features/Resources/peasant_combat_resource.tres")
	var object_res: Resource = load("res://Features/Resources/peasant_object_resource.tres")
	var new_warrior: PeasantUnit = PeasantUnit.create_unit(unit_res, combat_res, object_res)
	return new_warrior


func _on_spawn_timer_timeout() -> void:
	if spawn_queue.is_empty():
		return
	
	var unit = spawn_queue.pop_front()
	
	building.add_sibling(unit)
	unit.global_position += building.global_position + spawn_offset
	unit.setup(Vector2i(unit.global_position))
	#TODO: make the unit do something like below
	#unit.move_to(building.rally_point.global_position)
	#TODO: connect this to movement_service
	unit_spawned.emit(unit, rally_point.global_position)
	print("remaining: ", spawn_queue)
	
	if not spawn_queue.is_empty():
		timer.start(SPAWN_TIME)


func set_rally_point(pos: Vector2) -> void:
	rally_point.global_position = pos
