class_name BuildingFactory extends Node

@export var building_scene: PackedScene = preload("res://Features/Objects/base_building.tscn")


func create_building(layer: TileMapLayer, world_pos: Vector2) -> BaseBuilding:
	var building: BaseBuilding = building_scene.instantiate()
	building.position = layer.map_to_local(Vector2i(world_pos))
	building.modulate = building.placement_color
	add_child(building)
	building.collision.disabled = true
	
	return building
