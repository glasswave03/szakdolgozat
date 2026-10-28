## Handles the inputs and 
class_name BuildingPlacement extends Node

var map: MapScene
var placing_building: bool = false
var building_preview: BaseBuilding
var mouse_pos: Vector2
@onready var building_factory: BuildingFactory = BuildingFactory.new()



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
			if not building_preview.placement.is_overlapping:
				place_building()
	
	if event is InputEventKey:
		if event.pressed and event.is_action_pressed("ui_cancel"):
			building_preview.call_deferred("queue_free")
			building_preview = null
			placing_building = false
		
		if event.pressed and event.keycode == KEY_W:
			if not placing_building:
				building_preview = building_factory.preview_building(
					building_factory.building_scene, 
					map, 
					map.tilemap, 
					mouse_pos
					)
				placing_building = true


func place_building() -> void:
	#TODO: when placing a building, it should set points solid under itself
	#TODO: building should not know about the MapController, it should only get
	# the nuggets of data it needs to know about itself (current_cell, etc.)
	#TODO: BaseBuilding doesn't have a setup function yet
	#building.setup()
	building_preview.placement.placed.emit()
	building_preview.modulate = Color.WHITE
	
	building_preview = null
	placing_building = false
