## Controls every map-related object while players are in a match.
##
## Initiates everything required by the player to play.
class_name MapController extends Node2D

var map: MapScene
var tilemap: TileMapLayer
var camera: Camera2D
var camera_controller: CameraController

var selection: SelectionManager
var groups: GroupManager
var formations: FormationService
var movement: MovementService
var dragbox: DragboxService
var placement: BuildingPlacement
var interactions: InteractionService

var canvas: CanvasLayer
var ui: Control
var ui_actions: UIActionService

var tile_size: int
@onready var astar_grid: AStarGrid2D = AStarGrid2D.new()


func setup(_map: MapScene) -> void:
	map = _map
	tile_size = map.settings.tile_size
	tilemap = map.tilemap
	camera = map.camera
	add_child(map)
	
	camera_controller = CameraController.new(camera)
	add_child(camera_controller)
	
	
	formations = FormationService.new()
	movement = MovementService.new(formations, astar_grid, tilemap)
	dragbox = DragboxService.new(camera)
	add_child(dragbox)
	
	selection = SelectionManager.new()
	groups = GroupManager.new()
	placement = BuildingPlacement.new()
	placement.setup(map)
	add_child(selection)
	add_child(groups)
	add_child(placement)
	
	interactions = InteractionService.new()
	
	dragbox.released.connect(selection._on_dragbox_released)
	
	astar_grid_setup()
	
	canvas = CanvasLayer.new()
	canvas.name = "UserInterface"
	add_child(canvas)
	ui = preload("res://Features/UI/selection_ui.tscn").instantiate()
	ui.name = "SelectionUI"
	canvas.add_child(ui)
	
	selection.changed.connect(interactions._on_selection_changed)
	selection.changed.connect(ui._on_selection_changed)
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
			#TODO: check if the click has targeted anything
			movement.move_selected(selection.selected_objects, mouse_pos)
	
	if event is InputEventKey:
		if event.pressed:
			groups.handle_group_input(event as InputEventKey, selection)
		
		# Debug features
		if OS.has_feature("debug"):
			if event.pressed and event.keycode == KEY_Q:
				map.add_child(debug_spawn_warrior(mouse_pos))


func _on_object_clicked(object: BaseObject, event: InputEventMouseButton) -> void:
	selection._on_object_clicked(object, event)


func _on_object_targeted(object: BaseObject) -> void:
	interactions._on_object_targeted(object)


func _on_unit_spawned(unit: BaseUnit, rally_pos: Vector2) -> void:
	movement._on_unit_spawned(unit, rally_pos)


func debug_spawn_warrior(mouse_pos: Vector2) -> WarriorUnit:
	var unit_scene := load("res://Features/Objects/warrior_unit.tscn")
	var new_unit: BaseUnit = unit_scene.instantiate()
	new_unit.setup(tilemap.to_local(tilemap.local_to_map(mouse_pos)))
	new_unit.global_position = mouse_pos
	#TODO: replace line below with object spawned signal
	new_unit.clicked.connect(_on_object_clicked)
	new_unit.targeted.connect(_on_object_targeted)
	return new_unit
