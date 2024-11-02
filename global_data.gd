extends Node

@export var home_team : Team
@export var away_team : Team

signal update_home_score(score: int)
signal update_away_score(score: int)

signal draw_card
signal focus_ship (s : ShipData)
signal card_up(c : CardView)
signal select_card(c : CardView)
@export var all_cards : Array[CardData]
var all_ships : Dictionary # Key: String (ship_class), Value: ShipData
var players : Dictionary
var focused_ship
var local_player_team : Team

func _ready():
	for card in all_cards:
		all_ships[card.ship.ship_class] = card.ship
		print(all_ships[card.ship.ship_class])
	self.connect("focus_ship", _on_ship_focused)

func _on_ship_focused(s : ShipData):
	self.focused_ship = s

func home_score():
	home_team.score += 1
	emit_signal("update_home_score", home_team.score)
	
func away_score():
	away_team.score += 1
	emit_signal("update_away_score", away_team.score)

func _on_draw_timer_timeout() -> void:
	emit_signal("draw_card")
