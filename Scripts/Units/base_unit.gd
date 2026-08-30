class_name BaseUnit extends CharacterBody2D

signal death
signal damaged

@export var move_speed = 500.0
@export var health := 10.0:
	set = set_health

var selection_rect: Rect2
var selection_width: int
var select_mode : bool = false:
	set(value):
		select_mode = value
		if value:
			selection_rect = Rect2(Vector2(0, 0), Vector2(0, 0))
			selection_width = 1
		else:
			selection_rect = Rect2(0,0,0,0)
			selection_width = 0
		queue_redraw()

func _ready() -> void:
	name = "Unit"
	add_to_group("Unit")

func _draw():
	draw_rect(selection_rect, Color.GREEN, false, selection_width)
	draw_arc(selection_rect.position, 100, 0, 360, 100, Color.GREEN, selection_width)
 
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_S:
			velocity = Vector2.ZERO

func _physics_process(_delta):
	pass
	#if nav_agent.is_navigation_finished():
		#if animation_player.current_animation != "idle":
		#	animation_player.play("idle")
 
	#animation(delta)
	#var next_position = nav_agent.get_next_path_position()
	#var direction = (next_position - global_position).normalized()
	#velocity = direction * move_speed
	#move_and_slide()

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

func move_to(target_position):
	# TODO: make movement possible without navagent
	pass

func set_health(value):
	if value > health: 
		health = 0
		death.emit()
		return
	
	health = value
	if value > 0:
		damaged.emit()
