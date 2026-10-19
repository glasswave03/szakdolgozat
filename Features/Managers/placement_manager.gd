class_name PlacementManager extends Node

var placing_building: bool = false
var building_preview: BaseBuilding


func _process(_delta: float) -> void:
	if placing_building:
		var mouse_pos: Vector2 = Vector2.ZERO#camera.get_global_mouse_position()
		var local_pos: Vector2i = Vector2i.ZERO#Vector2i(tilemap.to_local(mouse_pos))
		var current_tile_pos: Vector2i = Vector2i.ZERO#tilemap.local_to_map(local_pos)
		building_preview.position = current_tile_pos
		
		if Input.is_action_just_pressed("mouse_left"):
			if not building_preview.is_overlapping:
				#TODO: when placing a building, it should set points solid under itself
				place_building()
		
		if Input.is_action_just_pressed("ui_cancel"):
			building_preview.call_deferred("queue_free")
			building_preview = null
			placing_building = false


func place_building(building: PackedScene) -> void:
	building_preview.placed.emit()
	
	# building should not know about the MapController, it should only get
	# the nuggets of data it needs to know about itself (current_cell, etc.)
	#building_preview.setup(self)
	
	building_preview.modulate = Color.WHITE
	building_preview.collision.disabled = false
	building_preview = null
	placing_building = false
