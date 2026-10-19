class_name CameraController extends Node

const MAX_ZOOM: Vector2 = Vector2(2.0, 2.0)
const MIN_ZOOM: Vector2 = Vector2(0.5, 0.5)
const SCROLL_SPEED: Vector2 = Vector2(0.1, 0.1)

var camera: Camera2D
var camera_speed: float = 1000.0


func _init(_camera: Camera2D) -> void:
	camera = _camera


func _process(_delta: float) -> void:
	move_camera()


func _input(event: InputEvent) -> void:
	camera_zoom(event)


func move_camera() -> void:
	if Input.is_action_pressed("camera_left"):
		camera.position.x -= camera_speed * get_process_delta_time()
	if Input.is_action_pressed("camera_right"):
		camera.position.x += camera_speed * get_process_delta_time()
	if Input.is_action_pressed("camera_up"):
		camera.position.y -= camera_speed * get_process_delta_time()
	if Input.is_action_pressed("camera_down"):
		camera.position.y += camera_speed * get_process_delta_time()


func camera_zoom(event: InputEvent) -> void:
	if event.is_action_pressed("scroll_up") and camera.zoom <= MAX_ZOOM:
		camera.zoom += SCROLL_SPEED
	if event.is_action_pressed("scroll_down") and camera.zoom >= MIN_ZOOM:
		camera.zoom -= SCROLL_SPEED
