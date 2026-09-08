class_name BaseBuilding extends BaseObject

@onready var collision: CollisionShape2D = $Collision


func _ready() -> void:
	add_to_group("Selectable")
	type = BaseObject.BUILDING
	max_health = 15
	selection_radius = 100


func _draw():
	draw_arc(selection_indicator.position, selection_radius, 0, 360, 100, Color.GREEN, selection_width)


func _on_damaged() -> void:
	print("building damaged: ", health, "/", max_health)


func _on_death() -> void:
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
			for unit in UnitManager.unit_selected:
				if unit != self:
					unit.deselect()
			
			UnitManager.unit_selected = [self]
