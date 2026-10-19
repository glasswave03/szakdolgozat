class_name MapController extends Node2D

const TILE_SIZE: int = 32
const WALL_TILE_COORD: Vector2i = Vector2i(2, 2)

@export var map_settings: Resource = preload("res://Settings/map_settings.tres")
@export var tilemap: TileMapLayer

@onready var astar_grid: AStarGrid2D = AStarGrid2D.new()
@onready var camera: Camera2D = $Camera
@onready var camera_controller: CameraController = CameraController.new(camera)
@onready var dragbox: DragBox = DragBox.new()

var selection: SelectionManager
var movement: MovementService
var groups: GroupManager


func _ready() -> void:
	astar_grid_setup()
	add_sibling.call_deferred(camera_controller)
	camera_controller.add_child(dragbox)


func setup(match_controller: MatchController) -> void:
	selection = match_controller.selection
	movement = match_controller.movement
	groups = match_controller.groups


func astar_grid_setup() -> void:
	var offset: int = TILE_SIZE / 2
	
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

var drawing: bool = false
var start_pos: Vector2 = Vector2.ZERO
var end_pos: Vector2 = Vector2.ZERO
var selection_rect: Rect2
var selection_width: int = 0



var placing_building: bool = false
var building_preview: BaseBuilding


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
	
	selection_rect = Rect2(rect_pos, rect_size)
	draw_rect(selection_rect, rect_color, false, selection_width)
	print("not yet using dragbox_service")


func _process(_delta: float) -> void:
	if placing_building:
		var mouse_pos: Vector2 = camera.get_global_mouse_position()
		var mouse_to_tile: Vector2i = Vector2i(get_tile_pos(mouse_pos))
		var current_tile_pos: Vector2i = tilemap.map_to_local(mouse_to_tile)
		building_preview.position = current_tile_pos
		
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
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			selection_box_drag()
		
		if event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
			selection_box_release()
		
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			movement.move_selected(selection.selected_objects, mouse_pos)
	
	if event is InputEventMouseMotion and drawing:
		end_pos = mouse_pos
		queue_redraw()
		selection.selected_rect = selection_rect
	
	#TODO: input_handler should handle key inputs i think...
	if event is InputEventKey:
		if event.pressed:
			groups.handle_group_input(event as InputEventKey, selection)
		
		if event.pressed and event.keycode == KEY_Q:
			var unit_scene := load("res://Features/Objects/base_unit.tscn")
			var new_unit: BaseUnit = unit_scene.instantiate()
			new_unit.setup(tilemap.to_local(tilemap.local_to_map(mouse_pos)))
			new_unit.position = mouse_pos
			add_child(new_unit)
			new_unit.clicked.connect(selection._on_object_clicked)
			print("unit spawned: ", new_unit)
		
		if event.pressed and event.keycode == KEY_W:
			if not placing_building:
				#building_preview = match_controller.building_factory.spawn_building(tilemap, mouse_to_tile)
				placing_building = true
				selection.clear_selection()


func selection_box_drag() -> void:
	selection_width = 2
	drawing = true
	start_pos = camera.get_global_mouse_position()
	end_pos = camera.get_global_mouse_position()

func selection_box_release() -> void:
	selection_width = 0
	drawing = false
	start_pos = Vector2.ZERO
	end_pos = Vector2.ZERO
	
	var objects: Array[BaseObject] = []
	
	for object: BaseObject in get_tree().get_nodes_in_group("Selectable"):
		if object.select_mode == true:
			objects.append(object)
	
	selection.select_objects(objects)
	
	queue_redraw()


func get_tile_pos(global_pos: Vector2) -> Vector2i:
	var local_pos: Vector2 = tilemap.to_local(global_pos)
	var tile_pos: Vector2i = tilemap.local_to_map(local_pos)
	return tile_pos
