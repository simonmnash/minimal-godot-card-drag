extends TextureButton

class_name CardView

var card_data_index : int :
	set (v):
		card_data = GlobalData.all_cards[card_data_index]
		card_data_index = v

var card_data : CardData :
	set(value):
		card_data = value
		%CardName.text = card_data.card_name

func _process(delta: float) -> void:
	$Sprite2D.position = get_local_mouse_position()

func _on_button_up() -> void:
	GlobalData.emit_signal("card_up", self)
	self.self_modulate.a = 1.0
	$Sprite2D.hide()
	%CardData.show()

func _on_button_down() -> void:
	self.self_modulate.a = 0.0
	$Sprite2D.show()
	%CardData.hide()
	GlobalData.emit_signal("select_card", self)

func _on_focus_entered() -> void:
	if not disabled:
		GlobalData.emit_signal("focus_ship", card_data.ship)

func _on_mouse_entered() -> void:
	if not disabled:
		GlobalData.emit_signal("focus_ship", card_data.ship)

func _on_mouse_exited() -> void:
	if pressed:
		pass
	else:
		GlobalData.emit_signal("focus_ship", null)
