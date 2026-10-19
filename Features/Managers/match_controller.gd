class_name MatchController 
extends Node
## Holds all instances of managers and controllers
##
## Doesn't actually do anything with them, just holds them. 
## When player is not in a match, these are deleted for performance.

@export var map: MapController
@export var ui: Control

@onready var player_manager := PlayerManager.new()
@onready var selection := SelectionManager.new()
@onready var groups := GroupManager.new()
@onready var building_factory := BuildingFactory.new()
@onready var formations := FormationService.new()
@onready var movement := MovementService.new(formations, map.astar_grid, map.tilemap)
@onready var inputs := InputHandler.new()
@onready var ui_actions := UIActionService.new()


func _ready() -> void:
	add_child(selection)
	add_child(groups)
	map.setup(self)
	ui.setup(selection)
	ui.spawn_requested.connect(ui_actions.spawn_units_at_selected_buildings)
	ui.destroy_requested.connect(ui_actions.destroy_selected_buildings)
