## Orchestrates the map while players are in a match.
class_name MapController extends Node2D

var tile_size: int = 32

@onready var astar_grid: AStarGrid2D = AStarGrid2D.new()

var camera_controller: CameraController
var map_scene: MapScene
var camera: Camera2D
var tilemap: TileMapLayer
var selection: SelectionManager
var groups: GroupManager
var formations: FormationService
var movement: MovementService
var dragbox: DragboxService


func map_setup() -> void:
	tile_size = map_scene.map_settings.TILE_SIZE


func setup(_map: MapScene) -> void:
	map_scene = _map
	tilemap = map_scene.tilemap
	camera = map_scene.camera
	
	camera_controller = CameraController.new(camera)
	
	formations = FormationService.new()
	movement = MovementService.new(formations, astar_grid, tilemap)
	dragbox = DragboxService.new(camera)
	add_child(dragbox)
	
	selection = SelectionManager.new()
	groups = GroupManager.new()
	add_child(selection)
	add_child(groups)
	
	dragbox.released.connect(selection._on_dragbox_released)
	
	astar_grid_setup()
	
	add_child(camera_controller)


func astar_grid_setup() -> void:
	var offset: int = tile_size / 2
	
	astar_grid.region = tilemap.get_used_rect()
	astar_grid.cell_size = Vector2(tile_size, tile_size)
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


var placing_building: bool = false
var building_preview: BaseBuilding


func _process(_delta: float) -> void:
	if placing_building:
		var mouse_pos: Vector2 = camera.get_global_mouse_position()
		var mouse_to_tile: Vector2i = Vector2i(get_tile_pos(mouse_pos))
		var cell_pos: Vector2i = tilemap.map_to_local(mouse_to_tile)
		building_preview.position = cell_pos
		
		if Input.is_action_just_pressed("mouse_left"):
			if not building_preview.is_overlapping:
				#TODO: when placing a building, it should set points solid under itself
				place_building()
		
		if Input.is_action_just_pressed("ui_cancel"):
			building_preview.call_deferred("queue_free")
			building_preview = null
			placing_building = false


func place_building() -> void:
	building_preview.placed.emit()
	building_preview.setup(self)
	building_preview.modulate = Color.WHITE
	building_preview.collision.disabled = false
	building_preview = null
	placing_building = false


func _unhandled_input(event: InputEvent) -> void:
	var mouse_pos: Vector2 = camera.get_global_mouse_position()
	
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			movement.move_selected(selection.selected_objects, mouse_pos)
	
	#TODO: input_handler should handle key inputs i think...
	if event is InputEventKey:
		if event.pressed:
			groups.handle_group_input(event as InputEventKey, selection)
		
		if event.pressed and event.keycode == KEY_Q:
			var unit_scene := load("res://Features/Objects/base_unit.tscn")
			var new_unit: BaseUnit = unit_scene.instantiate()
			new_unit.setup(tilemap.to_local(tilemap.local_to_map(mouse_pos)))
			new_unit.position = mouse_pos
			map_scene.add_child(new_unit)
			new_unit.clicked.connect(selection._on_object_clicked)
			print("unit spawned: ", new_unit)
		
		if event.pressed and event.keycode == KEY_W:
			if not placing_building:
				#building_preview = match_controller.building_factory.spawn_building(tilemap, mouse_to_tile)
				placing_building = true
				selection.clear_selection()


func get_tile_pos(global_pos: Vector2) -> Vector2i:
	var local_pos: Vector2 = tilemap.to_local(global_pos)
	var tile_pos: Vector2i = tilemap.local_to_map(local_pos)
	return tile_pos
