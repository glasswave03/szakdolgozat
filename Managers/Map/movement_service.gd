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
	var target_cell: Vector2i = tilemap.local_to_map(tilemap.to_local(global_pos))
	
	for object: BaseObject in objects:
		if not is_instance_valid(object): continue
		
		if object is BaseUnit:
			units.append(object)
		elif object is BaseBuilding:
			buildings.append(object)
	
	if not buildings.is_empty():
		for building: BaseBuilding in buildings:
			if building.has_unit_factory():
				var pos := tilemap.to_global(tilemap.map_to_local(target_cell))
				building.unit_factory.set_rally_point(pos)
	
	if units.is_empty(): return
	
	var positions := formation_service.create_formation(
		units.size(),
		target_cell
	)
	
	for i in range(min(units.size(), positions.size())):
		var path := grid.get_point_path(
			tilemap.local_to_map(units[i].global_position),
			positions[i]
		).slice(1)
		
		if not path.is_empty():
			units[i].set_path(path)


func _on_unit_spawned(unit: BaseUnit, rally_pos: Vector2):
	move_selected([unit], rally_pos)
