class_name BaseUnit extends CharacterBody2D

signal death
signal damaged

@export var move_speed = 250.0
@export var health := 10.0:
	set = set_health

var target_pos := Vector2.ZERO
var selection_indicator: Rect2
var selection_width: int
var selection_radius := 25
var select_mode : bool = false:
	set(value):
		select_mode = value
		if value:
			selection_indicator = Rect2(Vector2(0, 0), Vector2(0, 0))
			selection_width = 2
		else:
			selection_indicator = Rect2(0,0,0,0)
			selection_width = 0
		queue_redraw()

func _ready() -> void:
	name = "Unit"
	add_to_group("Unit")

func _draw():
	draw_arc(selection_indicator.position, selection_radius, 0, 360, 100, Color.GREEN, selection_width)

func _physics_process(delta):
	#if nav_agent.is_navigation_finished():
		#if animation_player.current_animation != "idle":
		#	animation_player.play("idle")
	#animation(delta)
	var direction = (target_pos - global_position).normalized()
	velocity = direction * move_speed
	
	if position.distance_squared_to(target_pos) < 5:
		velocity = Vector2.ZERO
	
	move_and_slide()

func select():
	select_mode = true

func deselect():
	select_mode = false

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			select_mode = true
			if event.ctrl_pressed:
				UnitManager.unit_selected.append(self)
			else:
				for unit in UnitManager.unit_selected:
					if unit != self:
						unit.deselect()
				UnitManager.unit_selected = [self]

func move_to(pos):
	target_pos = pos
	#animation_player.play("move")

func set_health(value):
	if value > health: 
		health = 0
		death.emit()
		return
	
	health = value
	if value > 0:
		damaged.emit()
