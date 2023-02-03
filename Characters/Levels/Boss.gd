extends Enemy

func sprites():
	return [$Polygon2D, $Polygon2D2, $Polygon2D3, $Polygon2D4]

func _killed():
	pass

func hit_with_spaceship(spaceship):
	spaceship.take_damage(10)
