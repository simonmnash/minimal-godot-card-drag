extends Control

var player : Player

var selected_card : CardView
var card_scene : PackedScene = preload("res://Views/card.tscn")
var ship_scene : PackedScene = preload("res://Views/Ship.tscn")

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

func select_card(c: CardView):
	focus_ship(c.card_data.ship)
	selected_card = c
	for card: CardView in %Hand.get_children():
		if card != c:
			card.disabled = true

func card_up(c : CardData):
	var p = get_global_mouse_position()
	var s : ShipView = ship_scene.instantiate()
	s.ship_date = ship_context_data
	s.ship_team = player.team
	s.position = %Battlefield.get_mouse_position()
	%Battlefield.add_child(s)
	for card: CardView in %Hand.get_children():
		card.disabled = false
	selected_card.queue_free()

func _ready() -> void:
	for i in range(0, 3):
		var c : CardView = card_scene.instantiate()
		GlobalData.all_cards.shuffle()
		c.card_data = GlobalData.all_cards[0]
		%Hand.add_child(c)
	GlobalData.connect("focus_ship", focus_ship)
	GlobalData.connect("card_up", card_up)
	GlobalData.connect("select_card", select_card)
	var p = Player.new()
	p.team = GlobalData.home_team
	player = p

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass

func _on_area_2d_mouse_entered() -> void:
	pass
	#print(ship_context_data)

func _on_sub_viewport_container_mouse_entered() -> void:
	pass
	#print(ship_context_data)
