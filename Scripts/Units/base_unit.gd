class_name BaseUnit extends BaseObject

@export var move_speed := 250.0
var target_pos := Vector2.ZERO


func _ready() -> void:
	group_type = "Unit"
	max_health = 10.0
	health = max_health
	$HealthBar.max_value = max_health
	$HealthBar.value = health
	add_to_group(selectable_type)
	add_to_group(group_type)


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


func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		handle_unit_select(event)


func handle_unit_select(event):
	if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		select_mode = true
		
		if event.ctrl_pressed:
			UnitManager.unit_selected.append(self)
		else:
			UnitManager.clear_freed_objects()
			for unit in UnitManager.unit_selected:
				if unit != self:
					unit.deselect()
			
			UnitManager.unit_selected = [self]
			health -= 3
		
		if event.double_click:
			handle_double_click(get_tree().get_nodes_in_group(group_type))


func handle_double_click(group):
	for unit in group:
		unit.select()
		UnitManager.unit_selected.append(unit)


func move_to(pos):
	target_pos = pos
	#animation_player.play("move")


func _on_damaged():
	$HealthBar.value = health
	print("Unit health: ", health, "/", max_health)


func _on_death():
	deselect()
	call_deferred("queue_free")
	print("Unit died")
