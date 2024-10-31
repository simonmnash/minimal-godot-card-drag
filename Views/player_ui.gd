extends Control

var player : Player

var selected_card : CardView
var card_scene : PackedScene = preload("res://Views/card.tscn")
var ship_scene : PackedScene = preload("res://Views/Ship.tscn")
@export var auto_play : bool = false :
	set( v ):
		auto_play = v
		$AutoplayTimer.start()

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

func card_up(card_view : CardView):
	var c = card_view.card_data
	var battlefield_position = %Battlefield.get_mouse_position()
	var card_index_in_hand = 0
	for card in %Hand.get_children():
		if card == card_view:
			break
		card_index_in_hand += 1
	rpc_id(1, "create_ship_at_position", 
		card_view.card_data.ship.ship_class,
		battlefield_position.x,
		battlefield_position.y,
		card_index_in_hand)
	for card: CardView in %Hand.get_children():
		card.disabled = false

@rpc("any_peer", "call_remote")
func create_ship_at_position(ship_class: String, pos_x: float, pos_y: float, card_index_in_hand: int):
	if multiplayer.is_server():
		var player_sender = multiplayer.get_remote_sender_id()
		var sending_player : Player = GlobalData.players[player_sender]
		var s : ShipView = ship_scene.instantiate()
		s.position = Vector2(pos_x, pos_y)
		s.ship_team = sending_player.team
		s.ship_class = ship_class
		s.get_node("Sprite2D").texture = GlobalData.all_ships[ship_class].texture
		s.texture_path = GlobalData.all_ships[ship_class].texture.resource_path
		%Battlefield.add_child(s)
		# TODO
		# Right now nothing stops two players from grabbing and playing the same card at the same time.
		# Add card costing and a lock on the card when one player grabs it.
		# For now - just let them both play it and check if it is still in the server hand before queue free..
		if %Hand.get_child(card_index_in_hand) != null:
			%Hand.get_child(card_index_in_hand).call_deferred("queue_free")

func _ready() -> void:
	GlobalData.connect("focus_ship", focus_ship)
	GlobalData.connect("card_up", card_up)
	GlobalData.connect("select_card", select_card)
	GlobalData.connect("draw_card", draw_card)

func begin_game() -> void:
	for i in range(0, 3):
		var c : CardView = card_scene.instantiate()
		GlobalData.all_cards
		c.card_data_index = randi_range(0, len(GlobalData.all_cards)-1)
		%Hand.add_child(c)
	if auto_play:
		$AutoplayTimer.start()

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass

func _on_area_2d_mouse_entered() -> void:
	pass

func _on_sub_viewport_container_mouse_entered() -> void:
	pass

func draw_card():
	if %Hand.get_child_count() < 7:
		var c : CardView = card_scene.instantiate()
		c.card_data_index = randi_range(0, len(GlobalData.all_cards)-1)
		%Hand.add_child(c)

func _on_autoplay_timer_timeout() -> void:
	if %Hand.get_child_count() > 0:
		var sending_player : Player = GlobalData.players[0]
		var card_index_in_hand = randi_range(0, %Hand.get_child_count()-1)
		# Get the card at random index
		var card_view : CardView = %Hand.get_child(card_index_in_hand)
		# Get a random position on the battlefield
		var battlefield_position = Vector2(
			randf_range(%Battlefield.size.x/2, %Battlefield.size.x),
			randf_range(0, %Battlefield.size.y)
		)
		# Mimic the RPC call from card_up
		create_ship_at_position(
			card_view.card_data.ship.ship_class,
			battlefield_position.x,
			battlefield_position.y,
			card_index_in_hand
		)
