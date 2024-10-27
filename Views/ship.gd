extends RigidBody2D
class_name ShipView

@export var ship_date : ShipData

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if ship_date == null:
		pass
	else:
		self.linear_velocity = Vector2(10.0, 0.0) * ship_date.speed * delta
