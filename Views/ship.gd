extends RigidBody2D
class_name ShipView

@export var ship_date : ShipData :
	set(v):
		ship_date = v
		current_health = ship_date.health

@export var ship_team : Team
var current_health : int
func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 4

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


func _on_body_entered(body: Node) -> void:
	print("HIT")
	if self.current_health > 0:
		self.current_health -= 1
	else:
		call_deferred("queue_free")
