extends TextureButton

func _process(delta: float) -> void:
	$Sprite2D.position = get_local_mouse_position()

func _on_button_up() -> void:
	self.self_modulate.a = 1.0
	$Sprite2D.hide()

func _on_button_down() -> void:
	self.self_modulate.a = 0.0
	$Sprite2D.show()
