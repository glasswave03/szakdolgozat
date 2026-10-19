class_name DragBox extends Node2D

signal released

var drawing: bool = false
var start_pos: Vector2 = Vector2.ZERO
var end_pos: Vector2 = Vector2.ZERO
var selection_rect: Rect2
var selection_width: int = 0

# the dragbox should only send a signal that the box has been released, the other managers should 
# catch it and do their own thing
# should this know about the camera? or should the camera know about this?
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
	#TODO: get mouse pos wired in
	var mouse_pos: Vector2 = Vector2.ZERO#camera.get_global_mouse_position()
	
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			selection_box_drag(mouse_pos)
		
		if event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
			selection_box_release()
	
	if event is InputEventMouseMotion and drawing:
		end_pos = mouse_pos + Vector2(10, 10)
		queue_redraw()
		#TODO: signal selection about the rect?
		#selection.selected_rect = selection_rect


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
	print("using dragbox service")
	
	#TODO: this should be put in an _on_dragbox_released
	#var objects: Array[BaseObject] = []
	#
	#for object: BaseObject in get_tree().get_nodes_in_group("Selectable"):
		#if object.select_mode == true:
			#objects.append(object)
	#
	#selection.select_objects(objects)
	
