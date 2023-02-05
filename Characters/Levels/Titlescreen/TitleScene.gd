extends Node2D

const IntroScene = preload("res://Characters/Levels/Intro/IntroScene.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	$LogoAnimation.play("FannyFade")
	await get_tree().create_timer(5.0).timeout
	$AnimationPlayer.play("Blackout")
	$LogoAnimation.play("SpikaFade")
	await get_tree().create_timer(4.0).timeout
	$AnimationPlayer.play("Fade Out")
	#await get_tree().create_timer(4.0).timeout
	#$AnimationPlayer.play("Fade In")
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Input.is_action_pressed("ui_accept")):
		var tween_screen = create_tween()
		tween_screen.tween_callback(func(): get_tree().change_scene_to_packed(IntroScene))
