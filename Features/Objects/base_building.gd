class_name BaseBuilding extends BaseObject

@onready var rally_point: Sprite2D = $RallyPoint


func _ready() -> void:
	group_type = "Building"
	#TODO: string group types should be declared using enums and added on setup
	add_to_group(group_type)
	add_to_group(selectable_type)
	max_health = 15
	health = max_health
	selection_size = 160
	selection_offset = Vector2(-80, -80)
	$HealthBar.max_value = max_health
	$HealthBar.value = health
	rally_point.position += Vector2(-20, 140)
	rally_point.visible = false


func _process(_delta: float) -> void:
	if select_mode:
		rally_point.visible = true
	else:
		rally_point.visible = false


func _on_damaged() -> void:
	$HealthBar.value = health


func _on_death() -> void:
	deselect()
	call_deferred("queue_free")
	print("building destroyed")


func set_rally_point(global_pos: Vector2) -> void:
	rally_point.global_position = global_pos
