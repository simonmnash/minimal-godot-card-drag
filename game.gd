extends Node

const player_ui = preload("res://Views/PlayerUI.tscn")

# Fires on the server when a new player connects.
func _on_jam_connect_player_connected(pid: int, username: String) -> void:
	var p = Player.new()
	p.username = username
	p.pid = pid
	if len(GlobalData.players) == 0:
		p.team = GlobalData.home_team
	elif len(GlobalData.players) == 1:
		p.team = GlobalData.away_team
	GlobalData.players[pid] = p
	if len(GlobalData.players) == 2:
		start_game()
		for player in GlobalData.players:
			toggle_singleplayer_button.rpc_id(player, false)
	else:
		toggle_singleplayer_button.rpc_id(pid, true)

func _on_button_pressed() -> void:
	# Call RPC to start game in singleplayer mode
	start_game.rpc()
	$Singleplayer.hide()

@rpc("any_peer", "call_remote")
func start_game() -> void:
	$PlayerUI.begin_game()
	GlobalData.get_node("DrawTimer").start()
	$Singleplayer.hide()
	$PlayerUI.show()
	if len(GlobalData.players) == 1:
		var bot = Player.new()
		bot.pid = 0
		bot.team = GlobalData.away_team
		GlobalData.players[0] = bot
		$PlayerUI.player = bot
		$PlayerUI.auto_play = true
		print($PlayerUI.auto_play)

@rpc("authority", "call_remote")
func toggle_singleplayer_button(visible: bool) -> void:
	$Singleplayer.visible = visible
