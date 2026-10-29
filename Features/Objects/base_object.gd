@abstract
class_name BaseObject extends Area2D

signal death
signal damaged
signal clicked(object: BaseObject, event: InputEventMouseButton)
signal targeted(object: BaseObject)

@export var object: Resource
var health: float:
	set = set_health

var selection_rect: Rect2
var selection_width: int
var selection_color: Color = Color.GREEN

@onready var selection_size: float = object.selection_size
@onready var selection_offset: Vector2 = Vector2(-selection_size/2, -selection_size/2)
@onready var select_mode: bool = object.select_mode:
	set = set_select_mode


func set_health(value: float) -> void:
	var health_before: float = health
	health = value
	
	if health <= 0:
		health = 0
		death.emit()
		return
	elif health_before <= health:
		if health > object.max_health:
			health = object.max_health
	
	else:
		damaged.emit()


func set_select_mode(value: bool) -> void:
	select_mode = value
	if value:
		selection_rect = Rect2(selection_offset, Vector2(selection_size, selection_size))
		selection_width = 2
	else:
		selection_rect = Rect2(0,0,0,0)
		selection_width = 0
	
	queue_redraw()


func _ready() -> void:
	health = object.max_health
	if object.selectable:
		add_to_group("Selectable", true)


func _draw() -> void:
	draw_rect(selection_rect, selection_color, false, selection_width)


func select() -> void:
	select_mode = true


func deselect() -> void:
	select_mode = false
