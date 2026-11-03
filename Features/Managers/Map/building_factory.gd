class_name BuildingFactory extends RefCounted

func preview_building(scene: PackedScene, parent: Node, layer: TileMapLayer, mouse_pos: Vector2) -> BaseBuilding:
	var building := scene.instantiate()
	parent.add_child(building)
	building.position = layer.map_to_local(Vector2i(mouse_pos))
	#TODO: there should be something like building.set_preview(true)
	# and change to false on placement
	building.modulate = building.placement_color
	building.clicked.connect(parent.get_parent()._on_object_clicked)
	
	return building
