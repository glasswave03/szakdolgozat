class_name BaseBuilding extends BaseObject

@onready var collision: CollisionShape2D = $Collision


func _ready() -> void:
	group_type = "Building"
	add_to_group(selectable_type)
	add_to_group(group_type)
	max_health = 15
	health = max_health
	selection_radius = 100
	$HealthBar.max_value = max_health
	$HealthBar.value = health


func _on_damaged() -> void:
	$HealthBar.value = health
	print("building damaged: ", health, "/", max_health)


func _on_death() -> void:
	deselect()
	call_deferred("queue_free")
	print("building destroyed")


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
