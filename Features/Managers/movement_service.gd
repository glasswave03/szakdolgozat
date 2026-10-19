class_name MovementService extends RefCounted

var formation_service: FormationService
var grid: AStarGrid2D
var tilemap: TileMapLayer


func _init(_formation_service: FormationService,
		_grid: AStarGrid2D,
		_tilemap: TileMapLayer
	) -> void:
	formation_service = _formation_service
	grid = _grid
	tilemap = _tilemap


func move_selected(objects: Array[BaseObject], global_pos: Vector2) -> void:
	var units: Array[BaseUnit] = []
	var buildings: Array[BaseBuilding] = []
	var target_cell := tilemap.local_to_map(tilemap.to_local(global_pos))
	
	for object: BaseObject in objects:
		if object is BaseUnit:
			units.append(object)
		elif object is BaseBuilding:
			buildings.append(object)
	
	if not buildings.is_empty():
		for building: BaseBuilding in buildings:
			building.set_rally_point(global_pos)
	
	if units.is_empty(): return
	
	var positions := formation_service.create_formation(
		objects.size(),
		target_cell
	)
	
	for i in range(min(units.size(), positions.size())):
		var path := grid.get_point_path(
			tilemap.local_to_map(units[i].global_position),
			positions[i]
		)
		
		if not path.is_empty():
			units[i].set_path(path)
