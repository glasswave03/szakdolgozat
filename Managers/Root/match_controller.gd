## Root of the match being played
##
## 
class_name MatchController extends Node

var maps: Dictionary[String, PackedScene] = {
	"test_map": preload("res://Features/Worlds/map1.tscn"),
	"small_map": preload("res://Features/Worlds/map2.tscn"),
	
}

@export var map_controller: MapController
@export var map: MapScene

var player_manager: PlayerManager


func _ready() -> void:
	#TODO: should be set up through the lobby menu
	player_manager = PlayerManager.new()
	add_child(player_manager)
	
	map_controller = MapController.new()
	add_child(map_controller)
	set_map_scene(maps.get("test_map"))
	map_controller.setup(map)
	


func set_map_scene(_map_scene: PackedScene) -> void:
	map = _map_scene.instantiate()
