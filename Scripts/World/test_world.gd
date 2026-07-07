extends Node2D

const MAX_ZOOM = Vector2(2.0, 2.0)
const MIN_ZOOM = Vector2(0.5, 0.5)

@export var camera_speed = 500.0
@export var scroll_speed = Vector2(0.11, 0.11)

func _process(delta: float) -> void:
	move_camera_left()
	move_camera_right()
	move_camera_up()
	move_camera_down()
	

func _input(event: InputEvent) -> void:
	zoom_camera_in(event)
	zoom_camera_out(event)
	
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
