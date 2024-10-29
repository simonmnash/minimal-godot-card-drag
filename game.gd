extends Node

const player_ui = preload("res://Views/PlayerUI.tscn")

func _on_jam_connect_player_connected(pid: int, username: String) -> void:
	pass

func _on_jam_connect_player_joined(pid: int, username: String) -> void:
	$PlayerUI.begin_game()
