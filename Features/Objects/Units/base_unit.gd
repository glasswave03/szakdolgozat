class_name BaseUnit extends BaseObject

@export var move_speed := 250.0
var target_pos := Vector2.ZERO
var current_cell: Vector2i
var target_cell: Vector2i
var path: PackedVector2Array

var is_set_up := false
var next_cell_id: int
var next_cell: Vector2i

func _ready() -> void:
	group_type = "Unit"
	max_health = 10.0
	health = max_health
	$HealthBar.max_value = max_health
	$HealthBar.value = health
	add_to_group(selectable_type)
	add_to_group(group_type)


func setup(_grid: AStarGrid2D) -> void:
	grid = _grid
	current_cell = pos_to_cell(global_position)
	target_cell = current_cell
	is_set_up = true


func _physics_process(_delta: float) -> void:
	### NO PATHFINDING ###
	#var direction = (target_pos - global_position).normalized()
	#velocity = direction * move_speed
	#if position.distance_to(target_pos) < 5:
	#	velocity = Vector2.ZERO
	#move_and_slide()
	######################
	
	### Pathfinding ###
	assert(is_set_up, "Unit is not set up")
	
	#TODO: if unit cant reach the next cell in some seconds, it will stop trying
	
	if next_cell_id == path.size() - 1:
		velocity = Vector2.ZERO
		global_position = path[-1]
		current_cell = pos_to_cell(global_position)
		path.clear()
	else:
		if not path.is_empty():
			var direction: Vector2 = (path[next_cell_id+1] - path[next_cell_id]).normalized()
			velocity = direction * move_speed
			if current_cell != pos_to_cell(global_position): 
				current_cell = pos_to_cell(global_position)
				print(current_cell)
			move_and_slide()
	
			if (path[next_cell_id+1] - global_position).length() < 4:
				current_cell = pos_to_cell(global_position)
				next_cell_id += 1
				next_cell = path[next_cell_id]
	
	#TODO: probably another movement algo is needed for correct functionality
	


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		handle_unit_select(event)


func handle_unit_select(event: InputEvent) -> void:
	if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		select_mode = true
		
		if event.ctrl_pressed:
			UnitManager.unit_selected.append(self)
		else:
			UnitManager.clear_freed_objects()
			for unit: Node in UnitManager.unit_selected:
				if unit != self:
					unit.deselect()
			
			UnitManager.unit_selected = [self]
		
		if event.double_click:
			# TODO: make it only select on-screen units
			# something to do with viewport rect
			handle_double_click(get_tree().get_nodes_in_group(group_type))


func handle_double_click(group: Array[Node]) -> void:
	for unit in group:
		unit.select()
		UnitManager.unit_selected.append(unit)


func move_to(pos: Vector2) -> void:
	recalculate_path(pos)
	if path.is_empty():
		return
	next_cell_id = 0
	#target_pos = pos
	#animation_player.play("move")


func _on_damaged() -> void:
	$HealthBar.value = health
	print("Unit health: ", health, "/", max_health)


func _on_death() -> void:
	deselect()
	call_deferred("queue_free")
	print("Unit died")


func recalculate_path(pos: Vector2) -> void:
	if not path.is_empty(): path.clear()
	target_cell = pos_to_cell(pos)
	path = grid.get_point_path(current_cell, target_cell)
	#path = (path as Array).map(func (p): return p + grid.cell_size / 2)
