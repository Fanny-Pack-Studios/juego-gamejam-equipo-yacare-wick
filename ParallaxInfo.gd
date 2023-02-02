extends Label

func _process(delta):
	text = "Scroll offset: " + str($"../../ParallaxBackground".scroll_offset)\
		+ "\n" + str("Distance left: ", $"../..".distance_left())\
		+ "\n" + str("Distance traveled: ", $"../..".distance_traveled())\
		+ "\n" + str("Level's length: ", $"../..".length())
