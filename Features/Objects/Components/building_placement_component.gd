extends Node2D

signal placed

@onready var overlap_area: Area2D = $Overlap

var is_overlapping: bool = false
var overlap_counter: int = 0
var overlap_color: Color = Color(1,0,0,0.3)
var placement_color: Color = Color(1,1,1,0.3)


func _process(_delta: float) -> void:
	if overlap_counter > 0:
		is_overlapping = true
		modulate = overlap_color
	else:
		is_overlapping = false
	
	if not is_overlapping and overlap_area.monitoring:
		modulate = placement_color


func _on_placed() -> void:
	overlap_area.monitoring = false
	modulate = Color.WHITE


func _on_body_entered(body: Node2D) -> void:
	overlap_counter += 1
	print("overlapping with: ", body)


func _on_body_exited(body: Node2D) -> void:
	overlap_counter -= 1
	print("overlap exited: ", body)
