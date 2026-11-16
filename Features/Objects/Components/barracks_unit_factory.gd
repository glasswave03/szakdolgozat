extends BaseUnitFactory


func _ready() -> void:
	spawn_time = 5.0


func queue_unit() -> void:
	if spawn_queue.size() >= QUEUE_LIMIT:
		printerr("reached max amount of units in queue!")
		return
	
	var unit: WarriorUnit = create_warrior()
	
	spawn_queue.push_back(unit)
	print("queued unit")
	
	if timer.is_stopped():
		timer.start(spawn_time)


func create_warrior() -> WarriorUnit:
	var new_warrior: WarriorUnit = WarriorUnit.create_unit()
	return new_warrior
