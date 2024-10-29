extends Node

@export var home_team : Team
@export var away_team : Team

signal update_home_score(score: int)
signal update_away_score(score: int)

signal draw_card
signal focus_ship (s : ShipData)
signal card_up(c : CardData)
signal select_card(c : CardView)
var all_cards : Array[CardData]
var all_ships : Dictionary # Key: String (ship_class), Value: ShipData

var focused_ship
var local_player_team : Team

func load_resource_folder(path='res://Data/Cards/') -> Array[CardData]:
	var scene_loads : Array[CardData] = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				if file_name.get_extension() == "tres":
					var full_path = path.path_join(file_name)
					print(full_path)
					scene_loads.append(load(full_path))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return scene_loads

func _ready():
	all_cards = load_resource_folder()
	# Build ships dictionary from cards
	for card in all_cards:
		all_ships[card.ship.ship_class] = card.ship
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
