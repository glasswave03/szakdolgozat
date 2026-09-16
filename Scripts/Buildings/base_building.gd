class_name BaseBuilding extends BaseObject

@warning_ignore("unused_signal")
signal placed

const SPAWN_TIME := 1.0
const QUEUE_LIMIT := 10

@onready var collision: CollisionShape2D = %Collision
@onready var timer: Timer = $SpawnTimer
@onready var gathering_indicator: Sprite2D = $GatheringIndicator

var spawn_offset := Vector2(-10, 70)
var spawn_queue := []
var is_overlapping := false
var overlap_counter := 0
var overlap_color := Color(1,0,0,0.3)
var placement_color := Color(1,1,1,0.3)

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
	gathering_indicator.position += Vector2(-20, 140)


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
		gathering_indicator.visible = true
	else:
		gathering_indicator.visible = false


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


func move_to(pos):
	gathering_indicator.global_position = pos


func spawn_unit():
	var new_unit = unit_scene.instantiate()
	spawn_queue.push_back(new_unit)
	print("pushed queue: ", spawn_queue)
	new_unit.position = position + spawn_offset
	await timer.timeout
	new_unit.target_pos = gathering_indicator.global_position


func _on_placed() -> void:
	%Overlap.monitoring = false
	modulate = Color.WHITE
	gathering_indicator.visible = true


func _on_timer_timeout() -> void:
	add_sibling(spawn_queue.pop_front())
	print("popped queue: ", spawn_queue)


func _on_area_body_entered(_body: Node2D) -> void:
	overlap_counter += 1
	print("overlapping with: ", _body)


func _on_area_body_exited(_body: Node2D) -> void:
	overlap_counter -= 1
	print("overlap exited")
