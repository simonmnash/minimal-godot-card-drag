extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_away_end_zone_body_entered(body: Node2D) -> void:
	GlobalData.home_score()
	body.queue_free()

func _on_home_end_zone_body_entered(body: Node2D) -> void:
	GlobalData.away_score()
	body.queue_free()
