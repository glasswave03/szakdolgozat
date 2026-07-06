extends Node2D

const CAMERA_SPEED = 100.0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("camera_left"):
		move_camera_left()
	if event.is_action_pressed("camera_right"):
		move_camera_right()
	if event.is_action_pressed("camera_up"):
		move_camera_up()
	if event.is_action_pressed("camera_down"):
		move_camera_down()
	
func move_camera_left():
	%Camera.position.x -= CAMERA_SPEED * get_process_delta_time()
	
func move_camera_right():
	%Camera.position.x += CAMERA_SPEED * get_process_delta_time()
	
func move_camera_up():
	%Camera.position.y -= CAMERA_SPEED * get_process_delta_time()
	
func move_camera_down():
	%Camera.position.y += CAMERA_SPEED * get_process_delta_time()
	
