extends Node

signal focus_ship (s : ShipData)
signal card_up(c : CardData)
signal select_card(c : CardView)
var all_cards : Array[CardData]

var focused_ship

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
	self.connect("focus_ship", _on_ship_focused)

func _on_ship_focused(s : ShipData):
	self.focused_ship = s
