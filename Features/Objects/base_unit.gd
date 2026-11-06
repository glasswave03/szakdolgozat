class_name BaseUnit extends BaseObject

static var scene: PackedScene = preload("res://Features/Objects/base_unit.tscn")

@export var unit_resource: Resource
@export var combat_resource: Resource

var is_set_up: bool = false
var target: BaseObject = null
var attack_cooldown: float
var current_cell: Vector2
var next_cell: Vector2
var current_path: PackedVector2Array
var current_path_index: int

@onready var team: PlayerManager.Teams = object.team
@onready var state: UnitResource.States = unit_resource.state
@onready var move_speed: float = unit_resource.move_speed
@onready var attack_damage: float = combat_resource.attack_damage
@onready var attack_rate: float = combat_resource.attack_rate
@onready var attack_range: float = combat_resource.attack_range
@onready var armor: float = combat_resource.armor


func _ready() -> void:
	$Sprite.texture = object.sprite
	
	health = object.max_health
	$HealthBar.max_value = object.max_health
	$HealthBar.value = health
	
	var group_name: StringName = object.get_group_name()
	add_to_group(group_name)
	
	if object.selectable:
		add_to_group("Selectable", true)


func setup(cell_pos: Vector2i) -> void:
	current_cell = cell_pos
	is_set_up = true


func _draw() -> void:
	draw_rect(selection_rect, selection_color, false, selection_width)


func _process(delta: float) -> void:
	assert(is_set_up, "Unit is not set up")
	
	if attack_cooldown > 0:
		attack_cooldown -= delta
	
	if state == unit_resource.States.STATE_DEAD:
		#TODO: play death animation
		return
	
	if target != null:
		target_check()
	
	if current_path.is_empty() and \
	not state in [unit_resource.States.STATE_DEAD, unit_resource.States.STATE_ATTACK] \
	or current_path_index >= current_path.size():
		state = unit_resource.States.STATE_IDLE
		return
	
	next_cell = current_path[current_path_index]
	
	global_position = global_position.move_toward(next_cell, move_speed * delta)
	
	if global_position.is_equal_approx(next_cell):
		current_path_index += 1
		current_cell = next_cell


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			clicked.emit(self, event)
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			get_tree().get_root().set_input_as_handled()
			targeted.emit(self)


func set_path(path: PackedVector2Array) -> void:
	current_path = path
	current_path_index = 0
	state = unit_resource.States.STATE_MOVE
	#TODO: animations


func target_check() -> void:
	if target == self or target.team == team: 
		target = null
		return
	
	if global_position.distance_to(target.global_position) > attack_range:
		#TODO: move in range
		print("out of range!")
	elif attack_cooldown <= 0:
		target.take_damage(attack_damage)
		attack_cooldown = attack_rate
		state = unit_resource.States.STATE_ATTACK


func take_damage(amount: float) -> void:
	var dmg_reduction := armor / (armor + 100.0)
	var actual_damage := amount * (1.0 - dmg_reduction)
	health -= actual_damage


func _on_damaged() -> void:
	$HealthBar.value = health


func _on_death() -> void:
	#TODO: instead of queue_free, state should be set to dead,
	# play death animation, after a timer it disappears and then queue_free
	state = unit_resource.States.STATE_DEAD
	deselect()
	call_deferred("queue_free")
	print("Unit died")


static func create_unit(unit_res: Resource, combat_res: Resource, object_res: Resource) -> BaseUnit:
	var new_unit: BaseUnit = scene.instantiate()
	new_unit.unit_resource = unit_res
	new_unit.combat_resource = combat_res
	new_unit.object = object_res
	return new_unit
