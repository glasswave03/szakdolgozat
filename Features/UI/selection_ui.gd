extends Control

signal spawn_requested
signal destroy_requested

@onready var building_ui: Control = $Layout/BuildingUI
@onready var unit_ui: Control = $Layout/UnitUI
@onready var unit_grid: GridContainer = $Layout/UnitUI/Grid

var selection: SelectionManager
var has_building := false
var has_unit := false


func _ready() -> void:
	building_ui.visible = false
	unit_ui.visible = false


func setup(_selection: SelectionManager) -> void:
	selection = _selection
	
	selection.changed.connect(_on_selection_changed)


func _on_spawn_btn_pressed() -> void:
	spawn_requested.emit()


func _on_destroy_btn_pressed() -> void:
	destroy_requested.emit()


func _on_selection_changed(objects: Array[BaseObject]) -> void:
	var units: Array[BaseUnit] = []
	
	for object: BaseObject in objects:
		if object is BaseBuilding:
			has_building = true
			
		elif object is BaseUnit:
			has_unit = true
			units.append(object)
	
	for unit: BaseUnit in units:
		unit_grid.add_child(make_unit_button(unit))
	
	unit_ui.visible = has_unit
	building_ui.visible = has_building
	print("selection changed!")


func make_unit_button(unit: BaseUnit) -> Button:
	var button: Button = Button.new()
	button.text = unit.name
	
	return button
