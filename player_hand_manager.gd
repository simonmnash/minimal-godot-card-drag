extends Control

var player_hands = {}
var hand_scene = preload("res://Views/PlayerHand.tscn")

func add_hand(pid: int) -> Node:
	var hand = hand_scene.instantiate()
	player_hands[pid] = hand
	add_child(hand)
	return hand

func get_hand_by_pid(pid: int) -> Node:
	return player_hands.get(pid)

func remove_hand(pid: int):
	if pid in player_hands:
		var hand = player_hands[pid]
		player_hands.erase(pid)
		hand.queue_free()
