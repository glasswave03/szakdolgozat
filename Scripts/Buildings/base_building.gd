class_name BaseBuilding extends BaseObject

signal placed

const SPAWN_TIME := 1.0
const QUEUE_LIMIT := 10

@onready var collision: CollisionShape2D = $Collision
@onready var timer: Timer = $SpawnTimer

var gathering_point: Vector2
var spawn_offset = Vector2(-10, 70)
var spawn_queue := []

# Spawnable units
var unit_scene = preload("res://Scenes/Units/base_unit.tscn")


func _ready() -> void:
	group_type = "Building"
	add_to_group(selectable_type)
	add_to_group(group_type)
	max_health = 15
	health = max_health
	selection_radius = 100
	$HealthBar.max_value = max_health
	$HealthBar.value = health


func _process(delta: float) -> void:
	if not spawn_queue.is_empty() and timer.time_left == 0:
		timer.start(SPAWN_TIME)
		print("timer started")
	$SpawnBar.value = timer.time_left


func _on_damaged() -> void:
	$HealthBar.value = health


func _on_death() -> void:
	deselect()
	call_deferred("queue_free")
	print("building destroyed")


func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		handle_unit_select(event)


func handle_unit_select(event):
	if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		select_mode = true
		
		if event.ctrl_pressed:
			UnitManager.unit_selected.append(self)
		else:
			UnitManager.clear_freed_objects()
			for unit in UnitManager.unit_selected:
				if unit != self:
					unit.deselect()
			
			UnitManager.unit_selected = [self]
			health -= 3


func spawn_unit():
	var new_unit = unit_scene.instantiate()
	spawn_queue.push_back(new_unit)
	print("pushed queue: ", spawn_queue)
	await timer.timeout
	new_unit.position = position + spawn_offset
	new_unit.target_pos = gathering_point + spawn_offset


func _on_placed() -> void:
	gathering_point = Vector2(position + spawn_offset)


func _on_timer_timeout() -> void:
	add_sibling(spawn_queue.pop_front())
	print("popped queue: ", spawn_queue)
