## Holds the settings, tilemap and camera of the map scene.
##
## Base class of all maps that can be created. Through the MapSettings
## Resource, you can add more data to the map.
## To make a new map, a new script extending MapScene needs to be created
## and configured through there. A TileMapLayer must be configured and a Camera2D must be added.
class_name MapScene extends Node2D

@export var map_settings: Resource
@export var tilemap: TileMapLayer
@export var camera: Camera2D
