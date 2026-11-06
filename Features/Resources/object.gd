class_name ObjectResource extends Resource

@export var name: String
@export var max_health: float
@export var selectable: bool = true
@export var selection_size: float
@export var group: Groups
@export var team: PlayerManager.Teams
var select_mode: bool = false

enum Groups {
	OBJECT,
	UNIT,
	BUILDING,
	
}


static func create_resource(
		_name: String, 
		_max_health: float, 
		_selectable: bool,
		_selection_size: float, 
		_group: Groups = Groups.OBJECT, 
		_team: PlayerManager.Teams = PlayerManager.Teams.TEAM_NEUTRAL, 
	) -> Resource:
	
	var res: Resource = ObjectResource.new()
	res.name = _name
	res.max_health = _max_health
	res.selectable = _selectable
	res.selection_size = _selection_size
	res.group = _group
	res.team = _team
	
	return res


func get_group_name() -> StringName:
	match group:
		Groups.OBJECT:
			return StringName("Object")
		Groups.UNIT:
			return StringName("Unit")
		Groups.BUILDING:
			return StringName("Building")
		_:
			return StringName("Unknown")
