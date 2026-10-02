class_name BaseBuilding extends BaseObject

@warning_ignore("unused_signal")
signal placed

const SPAWN_TIME: float = 1.0
const QUEUE_LIMIT: int = 10

@onready var collision: CollisionShape2D = %Collision
@onready var timer: Timer = $SpawnTimer
@onready var rally_point: Sprite2D = $GatheringIndicator

var spawn_offset: Vector2 = Vector2(-10, 70)
var spawn_queue: Array[CharacterBody2D] = []
var is_overlapping: bool = false
var overlap_counter: int = 0
var overlap_color: Color = Color(1,0,0,0.3)
var placement_color: Color = Color(1,1,1,0.3)

# Spawnable units
var unit_scene: Resource = preload("res://Features/Objects/Units/base_unit.tscn")


func _ready() -> void:
	group_type = "Building"
	add_to_group(group_type)
	max_health = 15
	health = max_health
	selection_size = 160
	selection_offset = Vector2(-80, -80)
	$HealthBar.max_value = max_health
	$HealthBar.value = health
	rally_point.position += Vector2(-20, 140)
	rally_point.visible = false


func _process(_delta: float) -> void:
	$SpawnBar.value = timer.time_left
	if not spawn_queue.is_empty() and timer.time_left == 0:
		timer.start(SPAWN_TIME)
	
	if overlap_counter > 0:
		is_overlapping = true
		modulate = overlap_color
	else:
		is_overlapping = false
	
	if not is_overlapping and %Overlap.monitoring:
		modulate = placement_color
	
	if select_mode:
		rally_point.visible = true
	else:
		rally_point.visible = false


func _on_damaged() -> void:
	$HealthBar.value = health


func _on_death() -> void:
	deselect()
	call_deferred("queue_free")
	print("building destroyed")


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			handle_selection(event)


func handle_selection(event: InputEvent) -> void:
	select_mode = true
	
	UnitManager.clear_freed_objects()
	for unit: CharacterBody2D in UnitManager.unit_selected:
		if unit != self:
			unit.deselect()
		
		UnitManager.unit_selected = [self]


func move_to(pos: Vector2) -> void:
	rally_point.global_position = pos


func spawn_unit() -> void:
	var new_unit: BaseUnit = unit_scene.instantiate()
	spawn_queue.push_back(new_unit)
	print("pushed queue: ", spawn_queue)
	new_unit.position = position + spawn_offset
	new_unit.setup(grid, tilemap)
	await timer.timeout


func _on_placed() -> void:
	%Overlap.monitoring = false
	modulate = Color.WHITE


func _on_timer_timeout() -> void:
	var created_unit: CharacterBody2D = spawn_queue.pop_front()
	add_sibling(created_unit)
	created_unit.move_to(rally_point.global_position)
	print("popped queue, remaining: ", spawn_queue)


func _on_area_body_entered(_body: Node2D) -> void:
	overlap_counter += 1
	print("overlapping with: ", _body)


func _on_area_body_exited(_body: Node2D) -> void:
	overlap_counter -= 1
	print("overlap exited")
