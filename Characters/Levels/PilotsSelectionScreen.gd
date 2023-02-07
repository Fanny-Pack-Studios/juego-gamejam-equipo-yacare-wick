extends Node2D

const PilotCard = preload("res://GUI/PilotCard.tscn")

func _ready():
	var new_pilots = Party.generate_new_pilots()
	Party.clean()
	
	$CanvasLayer/Copilot.scale = Vector2(0,0)
	$CanvasLayer/Pilot.scale = Vector2(0,0)
	$CanvasLayer/Instructor.scale = Vector2(0,0)
	await get_tree().process_frame

	new_pilots.map(func(pilot):
		var pilot_card = PilotCard.instantiate()
		pilot_card.pilot = pilot
		$CanvasLayer/VBoxContainer/HBoxContainer/GridContainer.add_child(pilot_card)
	)
	var cards = $CanvasLayer/VBoxContainer/HBoxContainer/GridContainer.get_children()
	
#	for i in range(0, cards.size()):
#		cards[i].set_pilot(available_pilots[i])
	
	for i in range(cards.size()):
		var card = cards[i]
		if(i < cards.size() - 1):
			card.focus_neighbor_bottom = card.get_path_to(cards[i + 1])
		if(i > 0):
			card.focus_neighbor_top = card.get_path_to(cards[i - 1])
		card.gui_input.connect(func(input):
			if input.is_action_pressed("primary_action") or input.is_action_pressed("ui_accept"):
				choose_pilot(card.pilot)
				var next_pilot_idx = cards.size()
				cards[(i + 1) % next_pilot_idx].grab_focus()
			elif input.is_action_pressed("secondary_action"):
				deselect_pilot()
		)
	cards.front().grab_focus()

func deselect_pilot():
	if(Party.instructor):
		Party.instructor = null
		$CanvasLayer/Instructor.disappear()
	elif(Party.copilot):
		Party.copilot = null
		$CanvasLayer/Copilot.disappear()
	elif(Party.pilot):
		Party.pilot = null
		$CanvasLayer/Pilot.disappear()

func choose_pilot(pilot):
	if(not Party.pilot):
		Party.assign_pilot(pilot)
		$CanvasLayer/Pilot.appear(pilot)
	elif(not Party.copilot):
		Party.assign_copilot(pilot)
		$CanvasLayer/Copilot.appear(pilot)
	elif(not Party.instructor):
		Party.assign_instructor(pilot)
		$CanvasLayer/Instructor.appear(pilot)
	else:
		next_level()

func next_level():
	get_tree().change_scene_to_packed(Party.next_level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$ParallaxBackground.scroll_offset += Vector2(20, 20) * delta
