extends Control

signal spawn_requested(buildings: Array[BaseBuilding])
signal destroy_requested(buildings: Array[BaseBuilding])

@onready var building_ui: Control = $Layout/BuildingUI
@onready var unit_ui: Control = $Layout/UnitUI
@onready var unit_grid: GridContainer = $Layout/UnitUI/Grid

var has_building := false
var has_unit := false
var units: Array[BaseUnit] = []
var buildings: Array[BaseBuilding] = []


func _ready() -> void:
	building_ui.visible = has_building
	unit_ui.visible = has_unit


func _on_spawn_btn_pressed() -> void:
	spawn_requested.emit(buildings)


func _on_destroy_btn_pressed() -> void:
	destroy_requested.emit(buildings)


func _on_selection_changed(objects: Array[BaseObject]) -> void:
	has_unit = false
	has_building = false
	units = []
	buildings = []
	
	for button in unit_grid.get_children():
		button.queue_free()
	
	for object: BaseObject in objects:
		if object is BaseBuilding:
			has_building = true
			buildings.append(object)
			
		elif object is BaseUnit:
			has_unit = true
			units.append(object)
	
	for unit: BaseUnit in units:
		unit_grid.add_child(make_unit_button(unit))
	
	unit_ui.visible = has_unit
	building_ui.visible = has_building

#TODO: on unit_button clicked: focuses on that single unit
func make_unit_button(unit: BaseUnit) -> Button:
	var button: Button = Button.new()
	button.text = unit.name
	
	return button
