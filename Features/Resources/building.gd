class_name BuildingResource extends Resource

@export var gold_cost: int
@export var size: Vector2

func calculate_tilesize() -> Vector2i:
	return Vector2i(int(ceilf(size.x/32)), int(ceilf(size.y/32)))
