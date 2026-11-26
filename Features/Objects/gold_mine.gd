## Resource players can gather
class_name GoldMine extends BaseObject

signal depleted

const team := PlayerManager.Teams.TEAM_NEUTRAL

var is_depleted: bool = false

@onready var sprite: Sprite2D = $Sprite
@onready var gold_amount: int = object.max_health


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			clicked.emit(self, event)
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			targeted.emit(self)
			print("is goldmine targetable: ", targeted.has_connections())
			get_tree().get_root().set_input_as_handled()


func _process(_delta: float) -> void:
	if gold_amount <= 0:
		depleted.emit()


func _on_depleted() -> void:
	is_depleted = true
	sprite.texture.region.x = 128
	input_pickable = false
	printerr("Gold mine is empty!")


func take_damage(amount: float) -> void:
	gold_amount -= int(amount)
