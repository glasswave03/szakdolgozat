class_name BaseUnit extends BaseObject

@export var move_speed := 250.0
var target_pos := Vector2.ZERO


func _ready() -> void:
	type = BaseObject.UNIT
	add_to_group("Selectable")


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
		handle_unit_select(event)


func handle_unit_select(event):
	if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		select_mode = true
		
		if event.ctrl_pressed:
			UnitManager.unit_selected.append(self)
		else:
			for unit in UnitManager.unit_selected:
				if unit != self:
					unit.deselect()
			
			UnitManager.unit_selected = [self]
		
		if event.double_click:
			handle_double_click(get_tree().get_nodes_in_group("Selectable"))


func handle_double_click(group):
	for unit in group:
		unit.select()
		UnitManager.unit_selected.append(unit)


func move_to(pos):
	target_pos = pos
	#animation_player.play("move")


func on_death():
	print("Unit died :c ", self)


func on_damaged():
	print("Unit health: ", health, "/", max_health)
