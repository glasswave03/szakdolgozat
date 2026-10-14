class_name BaseBuilding extends BaseObject

@onready var rally_point: Sprite2D = $GatheringIndicator


func _ready() -> void:
	group_type = "Building"
	add_to_group(group_type)
	# something should be done about this idk
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


func move_to(pos: Vector2) -> void:
	rally_point.global_position = tilemap.local_to_map(pos)
