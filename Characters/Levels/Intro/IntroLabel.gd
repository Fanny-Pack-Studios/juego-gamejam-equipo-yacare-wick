extends RichTextLabel

const IntroScene = preload("res://Characters/Levels/Intro/IntroScene.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = create_tween()
	tween.tween_property( self, "visible_characters", 1000,20.0)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_pressed("ui_accept")):
		var tween_screen = create_tween()
		tween_screen.tween_callback(func(): get_tree().change_scene_to_packed(IntroScene))
