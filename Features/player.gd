class_name Player extends Node

enum PlayerState {
	IN_LOBBY,
	SELECTING,
	PLACING,
}

@export var starting_gold: int = 30
@export var starting_wood: int = 10
@export var max_population: int = 50

var gold: int
var wood: int
var population: int
var team: PlayerManager.Teams
var state: PlayerState
#TODO: an instance of an online player that can control things independently
# from other players, only exception being the lobby admin which can move and
# kick it from lobbies
