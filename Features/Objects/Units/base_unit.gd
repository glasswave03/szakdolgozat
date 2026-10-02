class_name BaseUnit extends BaseObject

@export var move_speed := 250.0
var current_cell: Vector2i
var target_cell: Vector2i
var next_cell: Vector2
var is_set_up := false
var current_id_path: Array[Vector2i]
var debug_path: PackedVector2Array


func _ready() -> void:
	group_type = "Unit"
	max_health = 10.0
	health = max_health
	$HealthBar.max_value = max_health
	$HealthBar.value = health
	add_to_group(selectable_type)
	add_to_group(group_type)


func setup(_grid: AStarGrid2D, _tilemap: TileMapLayer) -> void:
	grid = _grid
	tilemap = _tilemap
	current_cell = tilemap.local_to_map(global_position)
	target_cell = current_cell
	is_set_up = true


func _physics_process(delta: float) -> void:
	#assert(is_set_up, "Unit is not set up")
	#TODO: if unit cant reach the next cell in some seconds, it will stop trying
	
	if current_id_path.is_empty(): return
	
	next_cell = tilemap.map_to_local(current_id_path.front())
	global_position = global_position.move_toward(next_cell, move_speed * delta)
	
	if global_position == next_cell:
		current_cell = current_id_path.pop_front()


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			handle_unit_select(event)


func handle_unit_select(event: InputEvent) -> void:
	select_mode = true
	
	if event.ctrl_pressed:
		if not UnitManager.unit_selected.has(self):
			UnitManager.unit_selected.append(self)
	else:
		UnitManager.clear_freed_objects()
		for unit: CharacterBody2D in UnitManager.unit_selected:
			if unit != self:
				unit.deselect()
		
		UnitManager.unit_selected = [self]
	
	if event.double_click:
		#TODO: make it only select on-screen units
		# something to do with viewport rect
		handle_double_click(get_tree().get_nodes_in_group(group_type))
	print("Units currently selected: ", UnitManager.unit_selected)
	print("Formation: ", UnitManager.get_formation(get_global_mouse_position()))

func handle_double_click(group: Array[Node]) -> void:
	UnitManager.deselect_units()
	for unit in group:
		unit.select()
		UnitManager.unit_selected.append(unit)


func move_to(pos: Vector2) -> void:
	var id_path := grid.get_id_path(
		tilemap.local_to_map(global_position), 
		tilemap.local_to_map(pos)
		).slice(1)
	
	if not id_path.is_empty():
		current_id_path = id_path
		debug_path = grid.get_point_path(
			tilemap.local_to_map(global_position), 
			tilemap.local_to_map(pos)
			)
	
	#TODO: animations


func _on_damaged() -> void:
	$HealthBar.value = health
	print("Unit health: ", health, "/", max_health)


func _on_death() -> void:
	deselect()
	call_deferred("queue_free")
	print("Unit died")
