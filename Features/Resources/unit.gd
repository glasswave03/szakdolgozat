class_name UnitResource extends Resource

@export var gold_cost: int
@export var move_speed: float


static func create_resource(
		_gold_cost: int, 
		_move_speed: float, 
	) -> Resource:
	
	var res: Resource = UnitResource.new()
	res.gold_cost = _gold_cost
	res.move_speed = _move_speed
	
	return res
