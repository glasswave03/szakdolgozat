class_name MatchController extends Node

var players := PlayerManager.new()
var selection := SelectionManager.new()
var groups := GroupManager.new()
var building_factory := BuildingFactory.new()
var formations := FormationService.new()
var movement := MovementService.new(formations)

func move_selected(target_tile: Vector2i) -> void:
	movement.move_selected(selection.selected_objects, target_tile)


func select_single(object: BaseObject) -> void:
	selection.select_single(object)


func clear_selection() -> void:
	selection.clear_selection()
