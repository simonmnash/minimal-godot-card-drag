extends MarginContainer

var ship_data : ShipData :
	set(v):
		ship_data = v
		%TextureRect.texture = ship_data.texture
		%Speed.text = str(ship_data.speed)
		%ShipClass.text = ship_data.ship_class
		%FireRate.text = str(ship_data.health)
