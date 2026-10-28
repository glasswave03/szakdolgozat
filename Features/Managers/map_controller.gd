## Controls every map-related object while players are in a match.
##
## Initiates everything required by the player to play.
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
var placement: BuildingPlacement
var ui: Control
var ui_actions: UIActionService


func map_setup() -> void:
	tile_size = map_scene.map_settings.TILE_SIZE


func setup(_map: MapScene) -> void:
	map_scene = _map
	tilemap = map_scene.tilemap
	camera = map_scene.camera
	
	camera_controller = CameraController.new(camera)
	add_child(camera_controller)
	
	formations = FormationService.new()
	movement = MovementService.new(formations, astar_grid, tilemap)
	dragbox = DragboxService.new(camera)
	add_child(dragbox)
	
	selection = SelectionManager.new()
	groups = GroupManager.new()
	placement = BuildingPlacement.new()
	placement.setup(map_scene)
	add_child(selection)
	add_child(groups)
	add_child(placement)
	
	dragbox.released.connect(selection._on_dragbox_released)
	
	astar_grid_setup()
	
	ui = $UserInterface/SelectionUI
	ui.setup(selection)
	ui_actions = UIActionService.new()
	
	ui.spawn_requested.connect(ui_actions.spawn_units_at_selected_buildings)
	ui.destroy_requested.connect(ui_actions.destroy_selected_buildings)


func astar_grid_setup() -> void:
	var offset: int = tile_size / 2
	
	astar_grid.region = tilemap.get_used_rect()
	astar_grid.cell_size = Vector2(tile_size, tile_size)
	astar_grid.default_compute_heuristic = AStarGrid2D.HEURISTIC_EUCLIDEAN
	astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_EUCLIDEAN
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
