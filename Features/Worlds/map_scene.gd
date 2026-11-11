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

func _ready() -> void:
	for object: BaseObject in get_tree().get_nodes_in_group("Selectable"):
		if object is BaseUnit:
			object.setup(tilemap.local_to_map(tilemap.to_local(object.global_position)))
		elif object is BaseBuilding:
			object.placed.emit()
