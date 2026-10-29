class_name BaseUnit extends BaseObject

signal attack

@export var unit: Resource

var attack_target: BaseObject

var current_cell: Vector2
var next_cell: Vector2
var is_set_up: bool = false
var current_path: PackedVector2Array
var current_path_index: int


func _ready() -> void:
	health = object.max_health
	$HealthBar.max_value = object.max_health
	$HealthBar.value = health
	
	var group_name: StringName = object.get_group_name()
	add_to_group(group_name)
	
	if object.selectable:
		add_to_group("Selectable", true)


func setup(cell_pos: Vector2i) -> void:
	unit.team = PlayerManager.Teams.TEAM_NEUTRAL
	current_cell = cell_pos
	is_set_up = true


func _draw() -> void:
	draw_rect(selection_rect, selection_color, false, selection_width)


func _physics_process(delta: float) -> void:
	assert(is_set_up, "Unit is not set up")
	
	if unit.state == unit.States.STATE_DEAD:
		#TODO: play death animation
		return
	
	if attack_target != null:
		target_check()
	
	if current_path.is_empty() and not unit.state in [unit.States.STATE_DEAD, unit.States.STATE_ATTACK] \
	or current_path_index >= current_path.size():
		unit.state = unit.States.STATE_IDLE
		return
	
	next_cell = current_path[current_path_index]
	
	var move_speed: float = unit.move_speed
	global_position = global_position.move_toward(next_cell, move_speed * delta)
	
	if global_position.is_equal_approx(next_cell):
		current_path_index += 1
		current_cell = next_cell


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			clicked.emit(self, event)
			print("unit clicked")
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			#TODO: maybe this isnt how this should be done?
			targeted.emit(self)
			print("unit targeted")


func set_path(path: PackedVector2Array) -> void:
	current_path = path
	current_path_index = 0
	unit.state = unit.States.STATE_MOVE
	#TODO: animations


func target_check() -> void:
	if global_position.distance_to(attack_target.global_position) < unit.attack_range:
		#TODO: move in range
		printerr("out of range!")
		#move_to(attack_target.position)
	else:
		if attack_target.team != unit.team:
			attack.emit()


func _on_attack() -> void:
	attack_target.take_damage(unit.attack_damage)
	unit.state = unit.States.STATE_ATTACK
	#TODO: wait for attack_rate timer to go off


func take_damage(amount: float) -> void:
	var armor: float = unit.armor
	var dmg_reduction := armor / (armor + 100.0)
	var actual_damage := amount * (1.0 - dmg_reduction)
	health -= actual_damage


func _on_damaged() -> void:
	$HealthBar.value = health
	print("Unit damaged: ", health)


func _on_death() -> void:
	#TODO: instead of queue_free, state should be set to dead,
	# play death animation, after a timer it disappears and then queue_free
	unit.state = unit.States.STATE_DEAD
	deselect()
	call_deferred("queue_free")
	print("Unit died")
