class_name GameManager extends Node

const FPS_TIMER_LIMIT: float = 1.0

@onready var match_controller: MatchController = $MatchController

@export var world: Node2D

var ui: CanvasLayer
var current_world: Node2D
var scene_cache: Dictionary = {}
var fps_timer: float = 0.0
var fps_label: Label


func _ready() -> void:
	Global.game_manager = self
	current_world = $MatchController/World/Map
	ui = $MatchController/UserInterface
	fps_label = $MatchController/UserInterface/DebugUI/FPSCounter
	
	var player1 := Player.new()
	var player2 := Player.new()
	player1.name = "testplayer"
	player2.name = "testenemy"
	
	#TODO: only start on button press
	_start_match([player1, player2])


func _process(delta: float) -> void:
	fps_timer += delta
	if fps_timer > FPS_TIMER_LIMIT:
		fps_timer = 0.0
		fps_label.text = "FPS: " + str(Engine.get_frames_per_second())


func _start_match(players: Array[Player]) -> bool:
	# for each player, give them a team number?
	if players.size() <= 1 or players.size() >= PlayerManager.Teams.TEAM_MAX:
		return false
	
	for i in range(players.size()):
		players[i].team = i+1
	
	return true


func change_world(new_scene: String, delete: bool = true) -> void:
	if current_world != null:
		if delete:
			var scene_path: String = current_world.scene_file_path
			current_world.queue_free()
			scene_cache.erase(scene_path)
		else:
			world.remove_child(current_world)
	
	var new_node: Node
	if scene_cache.has(new_scene):
		new_node = scene_cache[new_scene]
		if new_node.get_parent() == null:
			world.add_child(new_node)
		new_node.visible = true
	else:
		new_node = load(new_scene).instantiate()
		scene_cache[new_scene] = new_node
		world.add_child(new_node)
	
	current_world = new_node
