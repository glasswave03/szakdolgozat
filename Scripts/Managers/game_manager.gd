class_name GameManager extends Node

@export var gui: Control
@export var world: Node2D

var current_gui
var current_world
var scene_cache: Dictionary = {}

func _ready() -> void:
	Global.game_manager = self
	current_gui = $UI/MainMenu
	current_world = $World/MenuScreen
	
	if current_gui and current_gui.scene_file_path:
		scene_cache[current_gui.scene_file_path] = current_gui

func clear_gui() -> void:
	var scene_path = current_gui.scene_file_path
	current_gui.queue_free() # Removes node entirely
	scene_cache.erase(scene_path)

func change_gui(new_scene: String, delete: bool = true) -> void:
	if current_gui != null:
		if delete:
			var scene_path = current_gui.scene_file_path
			current_gui.queue_free() # Removes node entirely
			scene_cache.erase(scene_path)
		else:
			gui.remove_child(current_gui) # Keeps in memory, does not run
	
	var new_node: Node
	if scene_cache.has(new_scene):
		new_node = scene_cache[new_scene]
		if new_node.get_parent() == null:
			gui.add_child(new_node)
		new_node.visible = true
	else:
		new_node = load(new_scene).instantiate()
		scene_cache[new_scene] = new_node
		gui.add_child(new_node)
	
	current_gui = new_node

func change_world(new_scene: String, delete: bool = true) -> void:
	if current_world != null:
		if delete:
			var scene_path = current_world.scene_file_path
			current_world.queue_free() # Removes node entirely
			scene_cache.erase(scene_path)
		else:
			world.remove_child(current_world) # Keeps in memory, does not run
	
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
