class_name UnitResource extends Resource

@export var gold_cost: int
#region Stats
@export var move_speed: float
@export var attack_damage: float
@export var attack_rate: float
@export var attack_range: float
@export var armor: float
#endregion
@export var team: PlayerManager.Teams
@export var state: States = States.STATE_IDLE: set = set_state

enum States {
	STATE_IDLE,
	STATE_MOVE,
	STATE_FOLLOW,
	STATE_ATTACK,
	STATE_DEAD,
	STATE_MAX,
}


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
