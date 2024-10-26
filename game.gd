extends Control

var card_scene : PackedScene = preload("res://Views/card.tscn")

var ship_context_data : ShipData :
	set(v):
		ship_context_data = v
		if v != null:
			$ShipContext.ship_data = v
			$ShipContext.show()
		else:
			$ShipContext.hide()

func focus_ship(s : ShipData):
	ship_context_data = s

func _ready() -> void:
	for i in range(0, 5):
		var c : CardView = card_scene.instantiate()
		c.card_data = GlobalData.all_cards[0]
		%Hand.add_child(c)
	GlobalData.connect("focus_ship", focus_ship)
