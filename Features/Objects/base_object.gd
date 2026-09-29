class_name BaseObject extends CharacterBody2D

signal death
signal damaged

@export var max_health: float
@export var health: float = max_health:
	set(value):
		var health_before: float = health
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

var grid: AStarGrid2D
var group_type: String
var selectable_type: String = "Selectable"
var selection_rect: Rect2
var selection_width: int
var selection_size: int = 32
var selection_offset: Vector2 = Vector2(-16,-16)
var selection_color: Color = Color.GREEN
var select_mode: bool = false:
	set(value):
		select_mode = value
		if value:
			selection_rect = Rect2(selection_offset, Vector2(selection_size, selection_size))
			selection_width = 2
		else:
			selection_rect = Rect2(0,0,0,0)
			selection_width = 0
		
		queue_redraw()


func _ready() -> void:
	max_health = 10.0
	health = max_health
	add_to_group(selectable_type)


func _draw() -> void:
	draw_rect(selection_rect, selection_color, false, selection_width)


func select() -> void:
	select_mode = true


func deselect() -> void:
	select_mode = false


func move_to(_pos: Vector2) -> void:
	pass


func setup(_grid: AStarGrid2D) -> void:
	grid = _grid


func pos_to_cell(pos: Vector2) -> Vector2i:
	assert(grid, "No grid set")
	return pos / grid.cell_size
