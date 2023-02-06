extends Enemy

const PilotsSelectionScreen = preload("res://Characters/Levels/PilotsSelectionScreen.tscn")

func sprites():
	return []

func _killed():
	$"../..".next_level()

func hit_with_spaceship(spaceship):
	spaceship.take_damage(10)
