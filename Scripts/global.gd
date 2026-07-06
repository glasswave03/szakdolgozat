extends Node

var score: int = 0
var player_type: PlayerType
var game_manager: GameManager
const save_location = "user://save.json"
const ROTA = 360

enum PlayerType {DEFAULT, MOUSE, HOVER, ZIGZAG}

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
	
func add_score():
	score += 5
	
