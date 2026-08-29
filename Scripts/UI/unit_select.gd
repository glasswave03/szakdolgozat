extends Control

var dragging = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var area = Area2D.new()
			area.position = get_local_mouse_position()
			
			if not dragging and event.pressed:
				dragging = true
			if dragging and not event.pressed:
				dragging = false
