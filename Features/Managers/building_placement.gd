class_name BuildingPlacement extends Node

var map: MapScene
var placing_building: bool = false
var building_preview: BaseBuilding
@onready var building_factory: BuildingFactory = BuildingFactory.new()
@onready var mouse_pos: Vector2 = map.camera.get_global_mouse_position()



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
	
	if Input.is_action_just_pressed("mouse_left"):
		if not building_preview.placement.is_overlapping:
			#TODO: when placing a building, it should set points solid under itself
			place_building(building_factory.building_scene)
	
	if Input.is_action_just_pressed("ui_cancel"):
		building_preview.call_deferred("queue_free")
		building_preview = null
		placing_building = false


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			place_building(building_factory.building_scene)
	
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_W:
			if not placing_building:
				building_preview = building_factory.preview_building(
					building_factory.building_scene, 
					map, 
					map.tilemap, 
					mouse_pos
					)
				placing_building = true


func place_building(building: PackedScene) -> void:
	building.placement.placed.emit()
	#TODO: when placing a building, it should set points solid under itself
	#TODO: building should not know about the MapController, it should only get
	# the nuggets of data it needs to know about itself (current_cell, etc.)
	#TODO: BaseBuilding doesn't have a setup function yet
	#building.setup()
	
	building.modulate = Color.WHITE
	building.collision.disabled = false
	building = null
	placing_building = false
