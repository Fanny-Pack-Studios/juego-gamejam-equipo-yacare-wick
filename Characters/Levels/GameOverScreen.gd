extends Node2D

const Nivel1 = preload("res://Characters/Levels/Nivel1.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_pressed("ui_accept")):
			var tween = create_tween()
			tween.tween_property($CanvasLayer/FadeOut, "modulate", Color(0,0,0,1), 1)
			tween.tween_callback(func(): get_tree().change_scene_to_packed(Nivel1))
