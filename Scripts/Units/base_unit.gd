class_name BaseUnit extends CharacterBody2D

signal death
signal damaged

const SPEED = 100.0
const VICINITY = Vector2(10.0, 10.0)

@export var health := 10.0:
	set = set_health

var target

func _physics_process(delta: float) -> void:
	if target == position:
		velocity = Vector2.ZERO
	if Input.is_action_pressed("mouse_right"):
		target = get_local_mouse_position()
		velocity = target.normalized() * SPEED
	
	move_and_slide()
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_S:
			velocity = Vector2.ZERO

func in_vicinity_of(target):
	position - VICINITY
	position + VICINITY

func set_health(value):
	if value > health: 
		health = 0
		death.emit()
		return
	
	health = value
	if value < 0:
		damaged.emit()
