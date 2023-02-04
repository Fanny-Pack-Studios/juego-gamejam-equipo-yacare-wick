extends RichTextLabel

func _process(delta):
	var primary = "[img=200]res://addons/controller_icons/assets/key/z.png[/img]"
	var secondary = "[img=200]res://addons/controller_icons/assets/key/x.png[/img]"
	var new_text
	if(not Party.pilot):
		new_text = str("Choose a pilot by pressing ", primary)
	elif(not Party.copilot):
		new_text = str("Now, choose a co-pilot by pressing ", primary, " or undo your selection by pressing ", secondary)
	elif(not Party.instructor):
		new_text = str("Great! Now, choose a pilot to instruct the new generations by pressing ", primary)
	else:
		new_text = str("All set!, if you are ready to start the next trip, press ", primary)
	if(text != new_text):
		text = new_text
		var tween = create_tween()
		tween.tween_property(self, "modulate:a", 1.0, 0.3).from(0.0)
