class_name PlayerManager extends Node

enum Teams {
	TEAM_NEUTRAL,
	TEAM_ONE,
	TEAM_TWO,
	TEAM_THREE,
	TEAM_FOUR,
	TEAM_FIVE,
	TEAM_SIX,
	TEAM_MAX,
}

var players: Array[Player]

func add_player(player: Player) -> void:
	players.append(player)


func get_player_by_team(team: Teams) -> Player:
	return players.get(team)
