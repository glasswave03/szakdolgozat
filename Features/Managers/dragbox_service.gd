class_name DragboxService extends Node2D

signal released(rect: Rect2)

var camera: Camera2D
var drawing: bool = false
var start_pos: Vector2 = Vector2.ZERO
var end_pos: Vector2 = Vector2.ZERO
var selection_rect: Rect2
var selection_width: int = 0


func _init(_camera: Camera2D) -> void:
	camera = _camera


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


func _unhandled_input(event: InputEvent) -> void:
	var mouse_pos: Vector2 = camera.get_global_mouse_position()
	
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			selection_box_drag(mouse_pos)
		
		if event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
			selection_box_release()
	
	if event is InputEventMouseMotion and drawing:
		end_pos = mouse_pos
		queue_redraw()


func selection_box_drag(mouse_pos: Vector2) -> void:
	selection_width = 2
	drawing = true
	start_pos = mouse_pos
	end_pos = mouse_pos

func selection_box_release() -> void:
	released.emit(selection_rect)
	
	selection_width = 0
	drawing = false
	start_pos = Vector2.ZERO
	end_pos = Vector2.ZERO
	
	queue_redraw()
