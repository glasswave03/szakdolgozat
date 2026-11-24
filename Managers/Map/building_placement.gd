## Handles the building placement on the map
class_name BuildingPlacement extends Node

const BaseBuildingScene := preload("res://Features/Objects/base_building.tscn")
const BarracksScene := preload("res://Features/Objects/barracks_building.tscn")
const HouseScene := preload("res://Features/Objects/house_building.tscn")
const TownHallScene := preload("res://Features/Objects/town_hall_building.tscn")

const WALL_COORDS := Vector2i(1,0)

var map: MapScene
var placing_building: bool = false
var building_preview: BaseBuilding
var mouse_pos: Vector2


func setup(_map: MapScene) -> void:
	map = _map


func _process(_delta: float) -> void:
	if not placing_building: return
	
	mouse_pos = map.camera.get_global_mouse_position()
	
	var local_pos: Vector2 = map.tilemap.to_local(mouse_pos)
	var map_pos: Vector2i = map.tilemap.local_to_map(local_pos)
	var snapped_pos: Vector2 = map.tilemap.map_to_local(map_pos)
	
	var size: Vector2 = building_preview.building_res.size
	var half_tile: Vector2 = map.tilemap.tile_set.tile_size / 2
	var offset := Vector2(size.x/2, size.y/2) - half_tile
	building_preview.position = snapped_pos + offset


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if not placing_building: return
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if not building_preview.is_overlapping:
				place_building(mouse_pos)
	
	if event is InputEventKey:
		if event.pressed and event.is_action_pressed("ui_cancel"):
			if not placing_building: return
			building_preview.call_deferred("queue_free")
			building_preview = null
			placing_building = false
		
		if event.pressed and event.keycode == KEY_W:
			if not placing_building:
				building_preview = preview_building(
					BaseBuildingScene, 
					map, 
					map.tilemap, 
					mouse_pos
					)
				placing_building = true
		
		if event.pressed and event.keycode == KEY_E:
			if not placing_building:
				building_preview = preview_building(
					BarracksScene, 
					map, 
					map.tilemap, 
					mouse_pos
					)
				placing_building = true
		
		if event.pressed and event.keycode == KEY_R:
			if not placing_building:
				building_preview = preview_building(
					HouseScene, 
					map, 
					map.tilemap,
					mouse_pos
					)
				placing_building = true
		
		if event.pressed and event.keycode == KEY_T:
			if not placing_building:
				building_preview = preview_building(
					TownHallScene, 
					map, 
					map.tilemap, 
					mouse_pos
					)
				placing_building = true


func place_building(global_pos: Vector2) -> void:
	var tilemap := map.tilemap
	var local_pos: Vector2 = map.tilemap.to_local(global_pos)
	var coords: Vector2i = map.tilemap.local_to_map(local_pos)
	var tilesize: Vector2i = building_preview.building_res.calculate_tilesize()
	var cells: Array[Vector2i] = []
	
	for x in tilemap.get_used_rect().size.x:
		for y in tilemap.get_used_rect().size.y:
			if x >= 0 and x < tilesize.x and y >= 0 and y < tilesize.y:
				var cell_coords := Vector2i(coords.x + x, coords.y + y)
				
				#TODO: set to rubble coords on atlas
				tilemap.set_cell(cell_coords, 1, WALL_COORDS, 0)
			
			var tile_pos := Vector2i(
				x + tilemap.get_used_rect().position.x, 
				y + tilemap.get_used_rect().position.y
			)
			cells.append(tile_pos)
			
			var tile_data := tilemap.get_cell_tile_data(tile_pos)
			if tile_data == null or not tile_data.get_custom_data("walkable"):
				get_parent().astar_grid.set_point_solid(tile_pos, true)
	
	building_preview.placed.emit(cells)
	building_preview.modulate = Color.WHITE
	building_preview.death.connect(_on_building_destroyed.bind(building_preview))
	
	if building_preview.has_unit_factory():
		building_preview.unit_factory.unit_spawned.connect(get_parent()._on_unit_spawned)
	
	building_preview = null
	placing_building = false


func preview_building(scene: PackedScene, parent: Node, layer: TileMapLayer, _mouse_pos: Vector2) -> BaseBuilding:
	var building := scene.instantiate()
	parent.add_child(building)
	building.position = layer.map_to_local(Vector2i(_mouse_pos))
	building.modulate = building.placement_color
	
	return building


func _on_building_destroyed(building: BaseBuilding) -> void:
	for cell in building.occupied_cells:
		var tile_data := map.tilemap.get_cell_tile_data(cell)
		if tile_data == null or not tile_data.get_custom_data("walkable"):
			get_parent().astar_grid.set_point_solid(cell, false)
