extends Node

const save_location = "user://save.json"

var game_manager: GameManager
var contents_to_save: Dictionary = {
	"highscore": 0
}


func _ready() -> void:
	pass

func _save():
	var file = FileAccess.open(save_location, FileAccess.WRITE)
	file.store_var(contents_to_save.duplicate())
	file.close()

func _load():
	var file = FileAccess.open(save_location, FileAccess.READ)
	var data = file.get_var()
	file.close()
	
	var save_data = data.duplicate()
	contents_to_save.highscore = save_data.highscore
