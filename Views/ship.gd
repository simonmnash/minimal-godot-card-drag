extends RigidBody2D
class_name ShipView

@export var ship_date : ShipData
@export var ship_team : Team

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if multiplayer.is_server():
		if ship_date == null:
			pass
		else:
			if ship_team == GlobalData.home_team:
				self.linear_velocity = Vector2(10.0, 0.0) * ship_date.speed * delta
			else:
				self.linear_velocity = Vector2(-10.0, 0.0) * ship_date.speed * delta
