## Holds the settings, tilemap and camera of the map scene.
##
## Base class of all maps that can be created. Through the MapSettings
## Resource, you can add more data to the map.
class_name MapScene extends Node2D

@export var map_settings: MapSettings
@export var tilemap: TileMapLayer
@export var camera: Camera2D
