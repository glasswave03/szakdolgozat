class_name BuildingFactory extends RefCounted

@export var building_scene: PackedScene = preload("res://Features/Objects/base_building.tscn")


func preview_building(scene: PackedScene, parent: Node, layer: TileMapLayer, world_pos: Vector2) -> BaseBuilding:
	var building := scene.instantiate()
	building.position = layer.map_to_local(Vector2i(world_pos))
	building.modulate = building.placement_color
	parent.add_child(building)
	#TODO: the line below should be something like building.set_preview(true)
	# and change to false on placement
	building.collision.disabled = true
	
	return building
