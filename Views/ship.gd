extends RigidBody2D
class_name ShipView

var ship_date : ShipData  # Keep this for local reference

var ship_class : String :
	set(v):
		ship_class = v
		if v != null:
			ship_date = GlobalData.all_ships[v]  # Set the ship_data from the class
			current_health = ship_date.health
			$Sprite2D.texture = ship_date.texture

var texture_path : String :
	set (v):
		$Sprite2D.texture = load(v)
		texture_path = v

@export var ship_team : Team
var current_health : int

func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 4

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
	if multiplayer.is_server():
		if self.current_health > 0:
			self.current_health -= 1
		else:
			call_deferred("queue_free")
