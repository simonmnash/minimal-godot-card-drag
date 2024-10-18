extends Control


var card_scene : PackedScene = preload("res://card.tscn")

func _ready() -> void:
	for i in range(0, 5):
		var c = card_scene.instantiate()
		%Hand.add_child(c)
