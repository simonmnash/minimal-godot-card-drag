extends Control

var player : Player

var selected_card : CardView
var card_scene : PackedScene = preload("res://Views/card.tscn")
var ship_scene : PackedScene = preload("res://Views/Ship.tscn")
@export var auto_play : bool = false

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
	rpc_id(1, "create_ship_at_position", s)
	for card: CardView in %Hand.get_children():
		card.disabled = false
	selected_card.queue_free()

@rpc("any_peer", "call_remote")
func create_ship_at_position():
	pass

func begin_game() -> void:
	for i in range(0, 3):
		var c : CardView = card_scene.instantiate()
		GlobalData.all_cards.shuffle()
		c.card_data = GlobalData.all_cards[0]
		%Hand.add_child(c)
	GlobalData.connect("focus_ship", focus_ship)
	GlobalData.connect("card_up", card_up)
	GlobalData.connect("select_card", select_card)
	GlobalData.connect("draw_card", draw_card)
	var p = Player.new()
	p.team = GlobalData.home_team
	player = p
	if auto_play:
		$AutoplayTimer.start()

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass

func _on_area_2d_mouse_entered() -> void:
	pass
	#print(ship_context_data)

func _on_sub_viewport_container_mouse_entered() -> void:
	pass
	#print(ship_context_data)

func draw_card():
	if %Hand.get_child_count() < 7:
		var c : CardView = card_scene.instantiate()
		GlobalData.all_cards.shuffle()
		c.card_data = GlobalData.all_cards[0]
		%Hand.add_child(c)



func _on_autoplay_timer_timeout() -> void:
	if %Hand.get_child_count() > 0:
		var random_card_index = randi_range(0, %Hand.get_child_count()-1)
		select_card(%Hand.get_children()[random_card_index])
		var rand_x = randf_range(100.0, 1036.0)
		var rand_y = randf_range(50.0, 481.0)
		var s : ShipView = ship_scene.instantiate()
		ship_context_data = selected_card.card_data.ship
		s.ship_date = ship_context_data
		s.ship_team = player.team
		s.position = Vector2(rand_x, rand_y)
		%Battlefield.add_child(s)
		for card: CardView in %Hand.get_children():
			card.disabled = false
		selected_card.queue_free()
