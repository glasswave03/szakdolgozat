class_name InteractionService extends RefCounted

var units: Array[BaseUnit]


func _on_object_targeted(object: BaseObject) -> void:
	for unit: BaseUnit in units:
		if is_instance_valid(unit) and is_instance_valid(object):
			unit.target = object
			
			if unit == object: 
				print("same unit")
			elif unit.team == unit.target.team:
				print("same team")
			else:
				print(unit, " targeted ", unit.target.name)


func _on_selection_changed(selection: Array[BaseObject]) -> void:
	units.clear()
	for unit in selection:
		if unit is BaseUnit:
			units.append(unit)


func _on_gold_deposited(amount: int, to: Player) -> void:
	to.player_gold += amount
	print(amount, " gold deposited. player's gold now: ", to.player_gold)
