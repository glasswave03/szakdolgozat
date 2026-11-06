class_name UnitResource extends Resource

@export var gold_cost: int
@export var move_speed: float
@export var state: States = States.STATE_IDLE: set = set_state

enum States {
	STATE_IDLE,
	STATE_MOVE,
	STATE_FOLLOW,
	STATE_ATTACK,
	STATE_DEAD,
	STATE_MAX,
}


static func create_resource(
		_gold_cost: int, 
		_move_speed: float, 
		_attack_damage: float, 
		_attack_rate: float,
		_attack_range: float, 
		_armor: float, 
		_state: States = States.STATE_IDLE
	) -> Resource:
	
	var res: Resource = UnitResource.new()
	res.gold_cost = _gold_cost
	res.move_speed = _move_speed
	res.attack_damage = _attack_damage
	res.attack_rate = _attack_rate
	res.attack_range = _attack_range
	res.armor = _armor
	res.state = _state
	
	return res


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
