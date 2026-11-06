class_name Player extends Node

enum PlayerState {
	IN_LOBBY,
	SELECTING,
	PLACING,
}

var gold: int
var wood: int
var population: int
var team: PlayerManager.Teams
var state: PlayerState
#TODO: an instance of an online player that can control things independently
# from other players, only exception being the lobby admin which can move and
# kick it from lobbies
