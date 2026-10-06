extends Node2D

const MAX_ZOOM: Vector2 = Vector2(2.0, 2.0)
const MIN_ZOOM: Vector2 = Vector2(0.5, 0.5)
const SCROLL_SPEED: Vector2 = Vector2(0.1, 0.1)
const TILE_SIZE: int = 32
const WALL_TILE_COORD: Vector2i = Vector2i(2, 2)

@export var tilemap: TileMapLayer

var camera_speed: float = 1000.0
var drawing: bool = false
var start_pos: Vector2 = Vector2.ZERO
var end_pos: Vector2 = Vector2.ZERO
var selection_rect: Rect2
var selection_width: int = 0
var placing_building: bool = false
var selected_building: BaseBuilding
var astar_grid: AStarGrid2D = AStarGrid2D.new()


func _ready() -> void:
	var offset := TILE_SIZE / 2
	astar_grid.region = tilemap.get_used_rect()
	astar_grid.cell_size = Vector2(TILE_SIZE, TILE_SIZE)
	astar_grid.default_compute_heuristic = AStarGrid2D.HEURISTIC_EUCLIDEAN
	astar_grid.default_compute_heuristic = AStarGrid2D.HEURISTIC_EUCLIDEAN
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	astar_grid.jumping_enabled = false
	astar_grid.offset = Vector2(offset, offset)
	astar_grid.update()
	
	for x in tilemap.get_used_rect().size.x:
		for y in tilemap.get_used_rect().size.y:
			var tile_pos := Vector2i(
				x + tilemap.get_used_rect().position.x, 
				y + tilemap.get_used_rect().position.y
			)
			var tile_data := tilemap.get_cell_tile_data(tile_pos)
			
			if tile_data == null or not tile_data.get_custom_data("walkable"):
				astar_grid.set_point_solid(tile_pos, true)


func _draw() -> void:
	var rect_pos: Vector2 = start_pos
	var rect_size: Vector2 = end_pos - start_pos
	var rect_color: Color = Color.GREEN
	
	if rect_size.x < 0:
		rect_pos.x += rect_size.x
		rect_size.x = abs(rect_size.x)
	if rect_size.y < 0:
		rect_pos.y += rect_size.y
		rect_size.y = abs(rect_size.y)
	
	selection_rect = Rect2(rect_pos,rect_size)
	draw_rect(selection_rect, rect_color, false, selection_width)
	
	for unit: BaseUnit in UnitManager.get_units_from_selection():
		draw_polyline(unit.debug_path, Color.RED)


func _process(_delta: float) -> void:
	for unit: Node in UnitManager.get_units_from_selection():
		if unit.is_set_up:
			if unit.is_in_group("Unit") and not unit.current_id_path.is_empty() and unit.current_id_path.size() > 2:
				queue_redraw()
	
	move_camera()
	
	if placing_building:
		var mouse_pos: Vector2 = %Camera.get_global_mouse_position()
		var mouse_to_tile: Vector2i = Vector2i(get_tile_pos(mouse_pos))
		var current_tile_pos: Vector2i = tilemap.map_to_local(mouse_to_tile)
		selected_building.position = current_tile_pos
		
		if Input.is_action_just_pressed("mouse_left"):
			if not selected_building.is_overlapping:
				#TODO: when placing a building, it should set points solid under itself
				place_building()
		
		if Input.is_action_just_pressed("ui_cancel"):
			selected_building.call_deferred("queue_free")
			selected_building = null
			placing_building = false


func place_building() -> void:
	selected_building.placed.emit()
	selected_building.setup(astar_grid, tilemap)
	selected_building.modulate = Color.WHITE
	selected_building.collision.disabled = false
	selected_building = null
	placing_building = false


func _input(event: InputEvent) -> void:
	camera_zoom(event)
	
	var mouse_pos: Vector2 = %Camera.get_global_mouse_position()
	var mouse_to_tile: Vector2i = get_tile_pos(mouse_pos)
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			selection_box_drag()
		
		if event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
			selection_box_release()
		
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			UnitManager.move_to_position(tilemap, mouse_to_tile)
	
	if event is InputEventMouseMotion and drawing:
		end_pos = %Camera.get_global_mouse_position()
		queue_redraw()
		UnitManager.selected_rect = selection_rect
	
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_S:
			for unit: Node in UnitManager.unit_selected:
				unit.target_pos = unit.position
		
		if event.pressed and event.keycode in UnitManager.control_groups:
			UnitManager.make_group(event)
		
		if event.pressed and event.keycode == KEY_Q:
			var unit_scene := load("res://Features/Objects/Units/base_unit.tscn")
			var new_unit: CharacterBody2D = unit_scene.instantiate()
			new_unit.setup(astar_grid, tilemap)
			new_unit.position = mouse_pos
			add_child(new_unit)
			print("unit spawned: ", new_unit)
		
		if event.pressed and event.keycode == KEY_W:
			if not placing_building:
				selected_building = UnitManager.spawn_building(tilemap, mouse_to_tile)
				placing_building = true
				UnitManager.deselect_units()


func selection_box_drag() -> void:
	selection_width = 2
	drawing = true
	start_pos = %Camera.get_global_mouse_position()
	end_pos = %Camera.get_global_mouse_position()

func selection_box_release() -> void:
	selection_width = 0
	drawing = false
	start_pos = Vector2.ZERO
	end_pos = Vector2.ZERO
	
	for unit: CharacterBody2D in get_tree().get_nodes_in_group("Selectable"):
		if unit.select_mode == true:
			UnitManager.unit_selected.append(unit)
	queue_redraw()


func get_tile_pos(global_pos: Vector2) -> Vector2i:
	var local_pos: Vector2 = tilemap.to_local(global_pos)
	var tile_pos: Vector2i = tilemap.local_to_map(local_pos)
	return tile_pos

func move_camera() -> void:
	if Input.is_action_pressed("camera_left"):
		%Camera.position.x -= camera_speed * get_process_delta_time()
	if Input.is_action_pressed("camera_right"):
		%Camera.position.x += camera_speed * get_process_delta_time()
	if Input.is_action_pressed("camera_up"):
		%Camera.position.y -= camera_speed * get_process_delta_time()
	if Input.is_action_pressed("camera_down"):
		%Camera.position.y += camera_speed * get_process_delta_time()

func camera_zoom(event: InputEvent) -> void:
	if event.is_action_pressed("scroll_up") and %Camera.zoom <= MAX_ZOOM:
		%Camera.zoom += SCROLL_SPEED
	if event.is_action_pressed("scroll_down") and %Camera.zoom >= MIN_ZOOM:
		%Camera.zoom -= SCROLL_SPEED
