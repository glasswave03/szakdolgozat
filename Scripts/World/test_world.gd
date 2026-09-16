extends Node2D

const MAX_ZOOM = Vector2(2.0, 2.0)
const MIN_ZOOM = Vector2(0.5, 0.5)
const SCROLL_SPEED = Vector2(0.1, 0.1)

@export var camera_speed = 1000.0

var drawing := false
var start_pos := Vector2.ZERO
var end_pos := Vector2.ZERO
var selection_rect: Rect2
var width = 0
var is_building_selected := false
var selected_building


func _draw():
	var rect_pos = start_pos
	var rect_size = end_pos - start_pos
	var rect_color = Color.GREEN
	
	if rect_size.x < 0:
		rect_pos.x += rect_size.x
		rect_size.x = abs(rect_size.x)
	if rect_size.y < 0:
		rect_pos.y += rect_size.y
		rect_size.y = abs(rect_size.y)
	
	selection_rect = Rect2(rect_pos,rect_size)
	draw_rect(selection_rect, rect_color, false, width)

func _process(_delta: float) -> void:
	move_camera()
	
	if is_building_selected:
		var place_pos = %Ground.map_to_local(Vector2i(get_tile_pos(%Camera.get_global_mouse_position())))
		selected_building.position = place_pos
		if Input.is_action_just_pressed("mouse_left"):
			if not selected_building.is_overlapping:
				selected_building.placed.emit()
				selected_building.modulate = Color.WHITE
				selected_building.collision.disabled = false
				selected_building = null
				is_building_selected = false
		
		if Input.is_action_just_pressed("ui_cancel"):
			selected_building.call_deferred("queue_free")
			selected_building = null
			is_building_selected = false


func _input(event: InputEvent) -> void:
	camera_zoom(event)
	
	if event is InputEventMouseButton:
		handle_selection(event)
		
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			UnitManager.move_to_position(%Ground, get_tile_pos(%Camera.get_global_mouse_position()))
	
	if event is InputEventMouseMotion and drawing:
		end_pos = %Camera.get_global_mouse_position()
		queue_redraw()
		UnitManager.selected_rect = selection_rect
	
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_S:
			for unit in UnitManager.unit_selected:
				unit.target_pos = unit.position
		
		if event.pressed and event.keycode in UnitManager.control_groups:
			UnitManager.make_group(event)
		
		if event.pressed and event.keycode == KEY_W:
			if not is_building_selected:
				selected_building = UnitManager.spawn_building(%Ground,get_tile_pos(%Camera.get_global_mouse_position()))
				is_building_selected = true


func handle_selection(event):
	if is_building_selected:
		for unit in UnitManager.unit_selected:
			unit.deselect()
		
		UnitManager.unit_selected.clear()
		return
	
	if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		width = 2
		drawing = true
		start_pos = %Camera.get_global_mouse_position()
		end_pos = %Camera.get_global_mouse_position()
	
	if event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
		width = 0
		drawing = false
		start_pos = Vector2.ZERO
		end_pos = Vector2.ZERO
		queue_redraw()


func get_tile_pos(global_pos):
	var local_pos = %Ground.to_local(global_pos)
	var tile_pos = %Ground.local_to_map(local_pos)
	return tile_pos

func move_camera():
	if Input.is_action_pressed("camera_left"):
		%Camera.position.x -= camera_speed * get_process_delta_time()
	if Input.is_action_pressed("camera_right"):
		%Camera.position.x += camera_speed * get_process_delta_time()
	if Input.is_action_pressed("camera_up"):
		%Camera.position.y -= camera_speed * get_process_delta_time()
	if Input.is_action_pressed("camera_down"):
		%Camera.position.y += camera_speed * get_process_delta_time()

func camera_zoom(event):
	if event.is_action_pressed("scroll_up") and %Camera.zoom <= MAX_ZOOM:
		%Camera.zoom += SCROLL_SPEED
	if event.is_action_pressed("scroll_down") and %Camera.zoom >= MIN_ZOOM:
		%Camera.zoom -= SCROLL_SPEED
