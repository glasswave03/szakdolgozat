class_name GameManager extends Node

const FPS_TIMER_LIMIT: float = 1.0


#TODO: game_manager should not care about the map or matchcontroller, it should only care about
# switching between menu scenes and handling game start/end
@export var scene: Node

var fps_timer: float = 0.0
var match_controller: MatchController

@onready var current_scene: Node = $MainMenu
@onready var fps_label: Label = $Debug/UI/FPSCounter


func _ready() -> void:
	Global.game_manager = self
	


func _process(delta: float) -> void:
	fps_timer += delta
	if fps_timer > FPS_TIMER_LIMIT:
		fps_timer = 0.0
		fps_label.text = "FPS: " + str(Engine.get_frames_per_second())


func start_match(players: Array[Player]) -> bool:
	if players.size() <= 1 or players.size() >= PlayerManager.Teams.TEAM_MAX:
		return false
	
	match_controller = MatchController.new()
	add_child(match_controller)
	
	for i in range(players.size()):
		players[i].team = i+1 as PlayerManager.Teams
		match_controller.player_manager.players.append(players[i])
	
	current_scene = match_controller.map_controller.map
	return true


func change_scene(path: String) -> void:
	current_scene.queue_free()
	current_scene = load(path).instantiate()
	add_child(current_scene)


func quit_game() -> void:
	get_tree().quit(0)
