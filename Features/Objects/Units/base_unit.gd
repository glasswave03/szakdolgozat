class_name BaseUnit extends BaseObject

@export var unit_resource: Resource
@export var combat_resource: Resource

var is_set_up: bool = false
var target: BaseObject = null
var attack_cooldown: float
var current_cell: Vector2
var next_cell: Vector2
var current_path: PackedVector2Array
var current_path_index: int
var team: PlayerManager.Teams

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


func setup(cell_pos: Vector2i, map_controller: MapController) -> void:
	clicked.connect(map_controller._on_object_clicked)
	targeted.connect(map_controller._on_object_targeted)
	current_cell = cell_pos
	is_set_up = true


func _draw() -> void:
	draw_rect(selection_rect, selection_color, false, selection_width)


func _process(delta: float) -> void:
	assert(is_set_up, "Unit is not set up")
	
	if attack_cooldown > 0:
		attack_cooldown -= delta
	
	if target != null:
		target_check()
	
	if current_path.is_empty() or current_path_index >= current_path.size():
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
			targeted.emit(self)
			get_tree().get_root().set_input_as_handled()


func set_path(path: PackedVector2Array) -> void:
	current_path = path
	current_path_index = 0
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


func take_damage(amount: float) -> void:
	var dmg_reduction := armor / (armor + 15.0)
	var actual_damage := amount * (1.0 - dmg_reduction)
	health -= actual_damage
	#TODO: damage numbers?


func _on_damaged() -> void:
	$HealthBar.value = health


func _on_death() -> void:
	#TODO: instead of queue_free, state should be set to dead,
	# play death animation, after a timer it disappears and then queue_free
	deselect()
	call_deferred("queue_free")
	print("Unit died")


static func create_unit() -> BaseUnit:
	const SCENE: PackedScene = preload("res://Features/Objects/Units/base_unit.tscn")
	var new_unit: BaseUnit = SCENE.instantiate()
	var unit_res: Resource = load("res://Features/Resources/peasant_unit_resource.tres")
	var combat_res: Resource = load("res://Features/Resources/peasant_combat_resource.tres")
	var object_res: Resource = load("res://Features/Resources/peasant_object_resource.tres")
	new_unit.unit_resource = unit_res
	new_unit.combat_resource = combat_res
	new_unit.object = object_res
	return new_unit
