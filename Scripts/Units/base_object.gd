class_name BaseObject extends CharacterBody2D

signal death
signal damaged

enum {
	BASE,
	BUILDING,
	UNIT,
	OBSTACLE,
	RESOURCE,
}

@export var max_health: float
@export var type := BASE

var health := max_health:
	set(value):
		var health_before := health
		
		health = value
		if health <= 0:
			health = 0
			death.emit()
			return
		elif health_before <= health:
			if health > max_health:
				health = max_health
		
		else:
			damaged.emit()

var selection_indicator: Rect2
var selection_width: int
var selection_radius := 25
var select_mode: bool = false:
	set(value):
		select_mode = value
		if value:
			selection_indicator = Rect2(Vector2(0, 0), Vector2(0, 0))
			selection_width = 2
		else:
			selection_indicator = Rect2(0,0,0,0)
			selection_width = 0
		
		queue_redraw()


func _draw():
	draw_arc(selection_indicator.position, selection_radius, 0, 360, 100, Color.GREEN, selection_width)


func select():
	select_mode = true


func deselect():
	select_mode = false


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
