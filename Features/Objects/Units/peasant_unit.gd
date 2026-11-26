class_name PeasantUnit extends BaseUnit

signal deposit(gold: int, to: Player)

var assigned_goldmine: GoldMine
var current_gold: int
var max_gold: int = 10


func _ready() -> void:
	health = object.max_health
	$HealthBar.max_value = object.max_health
	$HealthBar.value = health
	
	var group_name: StringName = object.get_group_name()
	add_to_group(group_name)
	
	if object.selectable:
		add_to_group("Selectable", true)


func setup(cell_pos: Vector2i, map_controller: MapController) -> void:
	super(cell_pos, map_controller)
	deposit.connect(map_controller.interactions._on_gold_deposited)
	print("is deposit connected: ", deposit.has_connections())
	print(deposit.get_connections())


func interact() -> void:
	if attack_cooldown > 0.0:
		return
	print("targeted: ", target.name)
	attack_cooldown = combat_resource.rate
	
	if target.team != team and (target is BaseUnit or target is BaseBuilding):
		target.take_damage(attack_damage)
	elif target is GoldMine:
		if target.is_depleted:
			target = null
		elif current_gold < max_gold:
			collect_gold()
	elif target.team == team and target is TownHallBuilding:
		deposit_gold()
		if current_gold == 0:
			go_to_goldmine()
	else:
		#TODO: set path to target
		global_position = global_position.move_toward(
			target.global_position, move_speed * get_process_delta_time())


func collect_gold() -> void:
	var value: int = 0
	var gold_per_hit: int = int(attack_damage)
	
	# at this point we know that this is a mine
	assigned_goldmine = target
	
	if target.gold_amount < gold_per_hit and target.gold_amount > 0:
		value = target.gold_amount
	elif gold_per_hit + current_gold >= max_gold:
		value = (gold_per_hit + current_gold) - max_gold
	else:
		value = gold_per_hit
	
	print(target.gold_amount, " - ", value, " = ", target.gold_amount-value, " gold remaining in mine")
	target.take_damage(value)
	current_gold += value
	if current_gold == max_gold:
		take_gold_to_town_hall()
	print($Label.text, " collected ", value, " gold, holding: ", current_gold, "/", max_gold)


func take_gold_to_town_hall() -> void:
	var distance: float = INF
	for town_hall in get_parent().get_children():
		if town_hall is TownHallBuilding and town_hall.team == team:
			target = town_hall
	
	if distance == INF:
		printerr("No town halls detected on the map!")


func deposit_gold() -> void:
	var match_controller := get_parent().get_parent().get_parent()
	var player: Player = match_controller.player_manager.get_player_by_team(team)
	deposit.emit(current_gold, player)
	print("deposit success ", player.name, " has ", player.gold)
	current_gold = 0


func go_to_goldmine() -> void:
	target = assigned_goldmine


static func create_unit() -> PeasantUnit:
	const SCENE = preload("res://Features/Objects/Units/peasant_unit.tscn")
	
	var new_unit: PeasantUnit = SCENE.instantiate()
	var unit_res: Resource = load("res://Features/Resources/peasant_unit_resource.tres")
	var combat_res: Resource = load("res://Features/Resources/peasant_combat_resource.tres")
	var object_res: Resource = load("res://Features/Resources/peasant_object_resource.tres")
	new_unit.unit_resource = unit_res
	new_unit.combat_resource = combat_res
	new_unit.object = object_res
	return new_unit
