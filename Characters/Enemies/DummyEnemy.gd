extends Enemy

func sprites():
	return [$Polygon2D]

func _process(delta):
	pass

func _physics_process(delta):
	if(get_parent().get_parent() is Path2D):
		(get_parent() as PathFollow2D).progress += delta * 300

func hit_with_spaceship(spaceship):
	pass
