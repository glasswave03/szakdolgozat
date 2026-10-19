class_name BaseUnit extends BaseObject

signal attack

enum States {
	STATE_IDLE,
	STATE_MOVE,
	STATE_FOLLOW,
	STATE_ATTACK,
	STATE_DEAD,
	STATE_MAX,
}

@export var move_speed: float = 250.0
@export var attack_damage: float = 1.0
@export var attack_rate: float = 1.0
@export var attack_range: float = 10.0
@export var attack_target: BaseObject
@export var armor: float = 5.0

var state: States = States.STATE_IDLE: set = set_state
var current_cell: Vector2
var next_cell: Vector2
var is_set_up: bool = false
var current_path: PackedVector2Array
var current_path_index: int

@export var team: PlayerManager.Teams

func _ready() -> void:
	group_type = "Unit"
	max_health = 10.0
	health = max_health
	$HealthBar.max_value = max_health
	$HealthBar.value = health
	add_to_group(selectable_type)
	add_to_group(group_type)


func setup(cell_pos: Vector2i) -> void:
	#TODO: remove coupling
	team = PlayerManager.Teams.TEAM_NEUTRAL
	current_cell = cell_pos
	is_set_up = true


func _draw() -> void:
	draw_rect(selection_rect, selection_color, false, selection_width)


func _physics_process(delta: float) -> void:
	assert(is_set_up, "Unit is not set up")
	
	if state == States.STATE_DEAD:
		#TODO: play death animation
		return
	
	if attack_target != null:
		target_check()
	
	if current_path.is_empty() and not state in [States.STATE_DEAD, States.STATE_ATTACK] \
	or current_path_index >= current_path.size():
		state = States.STATE_IDLE
		return
	
	next_cell = current_path[current_path_index]
	
	global_position = global_position.move_toward(next_cell,move_speed * delta)
	
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
	state = States.STATE_MOVE
	#TODO: animations


func target_check() -> void:
	if global_position.distance_to(attack_target.global_position) < attack_range:
		#TODO: move in range
		printerr("out of range!")
		#move_to(attack_target.position)
	else:
		if attack_target.team != team:
			attack.emit()


func _on_attack() -> void:
	attack_target.take_damage(attack_damage)
	state = States.STATE_ATTACK
	#TODO: wait for attack_rate timer to go off


func take_damage(amount: float) -> void:
	var dmg_reduction := armor / (armor + 100.0)
	var damage := amount * (1.0 - dmg_reduction)
	health -= damage


func _on_damaged() -> void:
	$HealthBar.value = health
	print("Unit damaged: ", health)


func _on_death() -> void:
	#TODO: instead of queue_free, state should be set to dead,
	# play death animation, after a timer it disappears and then queue_free
	state = States.STATE_DEAD
	deselect()
	call_deferred("queue_free")
	print("Unit died")


func set_state(new_state: States) -> void:
	#var previous_state := state
	state = new_state
	
	match state:
		States.STATE_IDLE:
			#current_path.clear()
			#current_path_index = 0
			pass
		States.STATE_MOVE:
			#print("State changed to move")
			pass
		States.STATE_FOLLOW:
			print("State changed to follow")
			
		States.STATE_ATTACK:
			print("State changed to attack")
			
		States.STATE_DEAD:
			print("State changed to dead")
		_:
			printerr("Incorrect state set!")
