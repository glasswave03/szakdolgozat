## Root of the match being played
##
## 
class_name MatchController extends Node

@export var map_controller: MapController
@export var map: MapScene

var player_manager: PlayerManager


func _ready() -> void:
	#TODO: should be set up through the lobby menu
	#map_controller = MapController.new()
	#add_child(map_controller)
	#map = preload("res://Features/Worlds/map1.tscn").instantiate()
	#map_controller.add_child(map)
	map_controller.setup(map)
	
	player_manager = PlayerManager.new()
	add_child(player_manager)
