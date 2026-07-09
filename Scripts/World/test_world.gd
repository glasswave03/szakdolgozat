extends Node2D

const MAX_ZOOM = Vector2(2.0, 2.0)
const MIN_ZOOM = Vector2(0.5, 0.5)

@onready var ground = $Ground

@export var camera_speed = 500.0
@export var scroll_speed = Vector2(0.1, 0.1)

var drawing := false
var start_pos := Vector2.ZERO
var end_pos := Vector2.ZERO
var selection_rect: Rect2
var width = 0

func _draw():
	var rect_pos = start_pos
	var rect_size = end_pos - start_pos
	if rect_size.x < 0:
		rect_pos.x += rect_size.x
		rect_size.x = abs(rect_size.x)
	if rect_size.y < 0:
		rect_pos.y += rect_size.y
		rect_size.y = abs(rect_size.y)
 
	selection_rect = Rect2(rect_pos,rect_size)
	var rect_color = Color.RED
	draw_rect(selection_rect, rect_color, false, width)


func _process(delta: float) -> void:
	move_camera_left()
	move_camera_right()
	move_camera_up()
	move_camera_down()
	
# get viewports mouse pos and turn it into global pos?
# target.global_position = get_viewport().get_mouse_pos()?

func _input(event: InputEvent) -> void:
	zoom_camera_in(event)
	zoom_camera_out(event)
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			width = 2
			drawing = true
			start_pos = event.position
			end_pos = event.position
		if event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
			width = 0
			drawing = false
			start_pos = Vector2.ZERO
			end_pos = Vector2.ZERO
			queue_redraw()
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			UnitManager.move_to_position(ground,get_tile_pos(get_global_mouse_position()))
 
	if event is InputEventMouseMotion and drawing:
		end_pos = event.position
		queue_redraw()
		UnitManager.selected_rect = selection_rect
	
	
func get_tile_pos(global_pos):
	var local_pos = ground.to_local(global_pos)
	var tile_pos = ground.local_to_map(local_pos)
	return tile_pos
	
func move_camera_left():
	if Input.is_action_pressed("camera_left"):
		%Camera.position.x -= camera_speed * get_process_delta_time()
	
func move_camera_right():
	if Input.is_action_pressed("camera_right"):
		%Camera.position.x += camera_speed * get_process_delta_time()
	
func move_camera_up():
	if Input.is_action_pressed("camera_up"):
		%Camera.position.y -= camera_speed * get_process_delta_time()
	
func move_camera_down():
	if Input.is_action_pressed("camera_down"):
		%Camera.position.y += camera_speed * get_process_delta_time()
	
func zoom_camera_in(event):
	if event.is_action_pressed("scroll_up") and %Camera.zoom <= MAX_ZOOM:
		%Camera.zoom += scroll_speed
		print(%Camera.zoom)
	
func zoom_camera_out(event):
	if event.is_action_pressed("scroll_down") and %Camera.zoom >= MIN_ZOOM:
		%Camera.zoom -= scroll_speed
		print(%Camera.zoom)
