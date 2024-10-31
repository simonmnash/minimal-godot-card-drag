extends Resource
class_name  ShipData

@export var ship_class : String
@export var speed : float = 10.0
@export var health : int = 2
@export var texture : Texture2D :
	set(v):
		texture = v
		texture_path = texture.resource_path

var texture_path : String
