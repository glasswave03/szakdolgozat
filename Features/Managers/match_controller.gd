class_name MatchController 
extends Node
## Holds all instances of managers and controllers
##
## Doesn't actually do anything with them, just holds them. 
## When player is not in a match, these are deleted for performance.

@export var map_controller: MapController
@export var ui: Control
@export var map: MapScene

@onready var player_manager := PlayerManager.new()
@onready var building_factory := BuildingFactory.new()
@onready var inputs := InputHandler.new()
@onready var ui_actions := UIActionService.new()


func _ready() -> void:
	map_controller.setup(map)
	ui.spawn_requested.connect(ui_actions.spawn_units_at_selected_buildings)
	ui.destroy_requested.connect(ui_actions.destroy_selected_buildings)
