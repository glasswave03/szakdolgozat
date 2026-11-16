extends BaseUnitFactory

func _ready() -> void:
	spawn_time = 2.0


func queue_unit() -> void:
	if spawn_queue.size() >= QUEUE_LIMIT:
		printerr("reached max amount of units in queue!")
		return
	
	var unit: PeasantUnit = create_peasant()
	
	spawn_queue.push_back(unit)
	print("queued unit")
	
	if timer.is_stopped():
		timer.start(spawn_time)


func create_peasant() -> PeasantUnit:
	var new_peasant: PeasantUnit = PeasantUnit.create_unit()
	return new_peasant
