extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().process_frame
	var cards = $CanvasLayer/GridContainer.get_children()
	for i in range(cards.size()):
		var card = cards[i]
		if(i < cards.size() - 1):
			card.focus_neighbor_right = card.get_path_to(cards[i + 1])
		if(i > 0):
			card.focus_neighbor_left = card.get_path_to(cards[i - 1])
		card.gui_input.connect(func(input):
			if input.is_action_pressed("ui_accept"):
				next_level(card.pilot)
		)
	cards.front().grab_focus()

func next_level(pilot):
	Party.assign_pilots(pilot, pilot)
	get_tree().change_scene_to_packed(load("res://Characters/Levels/Nivel1.tscn"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$ParallaxBackground.scroll_offset += Vector2(20, 20) * delta
