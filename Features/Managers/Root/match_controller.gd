## Root of the match being played
##
## The lobby sets this up?
class_name MatchController extends Node

@export var map_controller: MapController
@export var map: MapScene

@onready var player_manager := PlayerManager.new()


func _ready() -> void:
	#TODO: should be set up through the lobby menu
	#map_controller = MapController.new()
	#add_child(map_controller)
	#map = preload("res://Features/Worlds/map1.tscn").instantiate()
	#map_controller.add_child(map)
	map_controller.setup(map)
