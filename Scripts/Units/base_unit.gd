class_name BaseUnit extends BaseObject

@export var move_speed := 250.0
var target_pos := Vector2.ZERO
var current_cell: Vector2i
var target_cell: Vector2i
var path: PackedVector2Array

var is_set_up := false
var next_cell: int

func _ready() -> void:
	group_type = "Unit"
	max_health = 10.0
	health = max_health
	$HealthBar.max_value = max_health
	$HealthBar.value = health
	add_to_group(selectable_type)
	add_to_group(group_type)


func setup(_grid: AStarGrid2D):
	grid = _grid
	current_cell = pos_to_cell(global_position)
	target_cell = current_cell
	is_set_up = true


func _physics_process(_delta):
	var direction = (target_pos - global_position).normalized()
	velocity = direction * move_speed
	if position.distance_to(target_pos) < 5:
		velocity = Vector2.ZERO
	
	#if not is_set_up: return
	
	#if next_cell == path.size() - 1:
	#	velocity = Vector2.ZERO
	#	global_position = path[-1]
	#	current_cell = pos_to_cell(global_position)
	#else:
	#	if not path.is_empty():
	#		var direction = (path[next_cell+1] - path[next_cell]).normalized()
	#		velocity = direction * move_speed
	#		move_and_slide()
			
	#		if (path[next_cell+1] - global_position).length() < 4:
	#			current_cell = pos_to_cell(global_position)
	#			next_cell += 1
	move_and_slide()


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
		
		if event.double_click:
			handle_double_click(get_tree().get_nodes_in_group(group_type))


func handle_double_click(group):
	for unit in group:
		unit.select()
		UnitManager.unit_selected.append(unit)


func move_to(pos):
	#if path.is_empty():
	#	return
	#next_cell = 0
	target_pos = pos
	#animation_player.play("move")


func _on_damaged():
	$HealthBar.value = health
	print("Unit health: ", health, "/", max_health)


func _on_death():
	deselect()
	call_deferred("queue_free")
	print("Unit died")


func recalculate_path(pos: Vector2) -> void:
	path.clear()
	target_cell = pos_to_cell(pos)
	path = grid.get_point_path(current_cell, target_cell)


func pos_to_cell(pos: Vector2) -> Vector2i:
	return pos / grid.cell_size
