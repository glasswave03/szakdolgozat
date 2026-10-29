class_name MatchController 
extends Node
## Holds all instances of managers and controllers
##
## Doesn't actually do anything with them, just holds them. 
## When player is not in a match, these are deleted for performance.

@export var map_controller: MapController
@export var map: MapScene

@onready var player_manager := PlayerManager.new()
@onready var building_factory := BuildingFactory.new()


func _ready() -> void:
	#TODO: map should be selected through the menus
	map_controller.setup(map)
