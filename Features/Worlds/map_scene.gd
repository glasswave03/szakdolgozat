## Holds the settings, tilemap and camera of the map scene.
##
## Base class of all maps that can be created. Through the MapSettings
## Resource, you can add more data to the map.
## To make a new map, a new script extending MapScene needs to be created
## and configured through there. A TileMapLayer must be configured and a Camera2D must be added.
class_name MapScene extends Node2D

@export var settings: Resource
@export var tilemap: TileMapLayer
@export var camera: Camera2D
@export var spawn_points: Array[Vector2]

func _ready() -> void:
	for child in get_children():
		if child is Marker2D:
			spawn_points.append(child.global_position)
	
	for object: BaseObject in get_tree().get_nodes_in_group("Selectable"):
		var tile_pos: Vector2i = tilemap.local_to_map(tilemap.to_local(object.global_position))
		
		if object is BaseUnit:
			var map_controller := get_parent()
			object.setup(tile_pos, map_controller)
		
		elif object is BaseBuilding:
			var cells: Array[Vector2i] = []
			var size: Vector2i = object.building_res.calculate_tilesize()
			
			for x in size.x:
				for y in size.y:
					cells.append(Vector2i(tile_pos.x + x, tile_pos.y + y))
			
			#TODO: add town halls to spawn points or spawn them on match start
			print(cells)
			object.placed.emit(cells)


func setup_objects() -> void:
	var map_controller := get_parent()
	var targeted_func: Callable = map_controller.interactions._on_object_targeted
	
	for child in get_children():
		if child is GoldMine:
			child.targeted.connect(targeted_func)
