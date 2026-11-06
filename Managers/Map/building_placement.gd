## Handles the building placement on the map
class_name BuildingPlacement extends Node

var map: MapScene
var placing_building: bool = false
var building_preview: BaseBuilding
var mouse_pos: Vector2


func setup(_map: MapScene) -> void:
	map = _map


func _process(_delta: float) -> void:
	if not placing_building: return
	#TODO: set player state to placing
	mouse_pos = map.camera.get_global_mouse_position()
	
	var local_pos: Vector2 = map.tilemap.to_local(mouse_pos)
	var map_pos: Vector2i = map.tilemap.local_to_map(local_pos)
	var snapped_pos: Vector2 = map.tilemap.map_to_local(map_pos)
	#TODO: this offset should be in the building_scene data or somewhere
	# to be able to automatically get it and use it here
	building_preview.position = snapped_pos - Vector2(-16, -16)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if not placing_building: return
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if not building_preview.is_overlapping:
				place_building()
	
	if event is InputEventKey:
		if event.pressed and event.is_action_pressed("ui_cancel"):
			if not placing_building: return
			building_preview.call_deferred("queue_free")
			building_preview = null
			placing_building = false
		
		if event.pressed and event.keycode == KEY_W:
			if not placing_building:
				building_preview = preview_building(
					BaseBuilding.scene, 
					map, 
					map.tilemap, 
					mouse_pos
					)
				placing_building = true
		
		if event.pressed and event.keycode == KEY_E:
			if not placing_building:
				building_preview = preview_building(
					BarracksBuilding.scene, 
					map, 
					map.tilemap, 
					mouse_pos
					)
				placing_building = true


func place_building() -> void:
	#TODO: when placing a building, it should set points solid under itself
	building_preview.placed.emit()
	building_preview.modulate = Color.WHITE
	
	building_preview = null
	placing_building = false


func preview_building(scene: PackedScene, parent: Node, layer: TileMapLayer, _mouse_pos: Vector2) -> BaseBuilding:
	var building := scene.instantiate()
	parent.add_child(building)
	building.position = layer.map_to_local(Vector2i(_mouse_pos))
	#TODO: there should be something like building.set_preview(true)
	# and change to false on placement
	building.modulate = building.placement_color
	building.clicked.connect(parent.get_parent()._on_object_clicked)
	
	return building
