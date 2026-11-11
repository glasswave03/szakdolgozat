class_name BaseBuilding extends BaseObject

signal placed

@export var building_res: Resource

var is_overlapping: bool = false
var overlap_counter: int = 0
var overlap_color: Color = Color(1,0,0,0.3)
var placement_color: Color = Color(1,1,1,0.3)

func _ready() -> void:
	var group_name: StringName = object.get_group_name()
	add_to_group(group_name)
	
	health = object.max_health
	$HealthBar.max_value = object.max_health
	$HealthBar.value = health
	$HealthBar.visible = false
	
	if object.selectable:
		add_to_group("Selectable", true)


func _on_damaged() -> void:
	$HealthBar.value = health


func destroy() -> void:
	#TODO: disable interaction and await animations
	death.emit()


func _on_death() -> void:
	deselect()
	call_deferred("queue_free")
	print("building destroyed")


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			clicked.emit(self, event)
		
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			#TODO: maybe this isnt how this should be done?
			targeted.emit(self)


func has_unit_factory() -> bool:
	return false


#region placement
func _process(_delta: float) -> void:
	if not monitoring: return
	
	if overlap_counter > 0:
		is_overlapping = true
		modulate = overlap_color
	else:
		is_overlapping = false
	
	if not is_overlapping and monitoring:
		modulate = placement_color


func _on_placed() -> void:
	var map_controller = get_parent().get_parent()
	clicked.connect(map_controller._on_object_clicked)
	
	monitoring = false
	modulate = Color.WHITE
	$HealthBar.visible = true


func _on_area_entered(area: Node2D) -> void:
	overlap_counter += 1
	print("overlapping with ", overlap_counter, " objects, detected ", area)


func _on_area_exited(area: Node2D) -> void:
	overlap_counter -= 1
	print("overlap exited: ", area)
#endregion
