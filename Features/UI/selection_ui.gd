extends Control

signal spawn_requested(buildings: Array[BaseBuilding])
signal destroy_requested(buildings: Array[BaseBuilding])

@onready var building_ui: Control = $Layout/BuildingUI
@onready var unit_ui: Control = $Layout/UnitUI
@onready var unit_grid: GridContainer = $Layout/UnitUI/Grid
@onready var map_controller := get_parent().get_parent()

var has_building := false
var has_unit := false
var units: Array[BaseUnit] = []
var buildings: Array[BaseBuilding] = []
var unit_buttons: Array[Button] = []


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
		var new_button := make_unit_button(unit)
		unit_grid.add_child(new_button)
		unit_buttons.append(new_button)
		
	
	unit_ui.visible = has_unit
	building_ui.visible = has_building


func make_unit_button(unit: BaseUnit) -> Button:
	var button: Button = Button.new()
	button.text = unit.object.name
	var button_press: Callable = map_controller.selection._on_unit_button_pressed
	button.pressed.connect(button_press.bind(unit))
	
	return button
