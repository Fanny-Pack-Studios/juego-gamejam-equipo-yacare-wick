extends RichTextLabel

const PilotScreen = preload("res://Characters/Levels/PilotsSelectionScreen.tscn")
# Called when the node enters the scene tree for the first time.
var tween

func _ready():
	tween = create_tween()
	tween.tween_property( self, "visible_ratio", 1.0,20.0).from(0.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _input(event):
	if(event.is_action_pressed("ui_accept")):
		if(visible_ratio < 0.9):
			tween.stop()
			visible_ratio = 1
		else:
			get_tree().change_scene_to_packed(PilotScreen)
		
