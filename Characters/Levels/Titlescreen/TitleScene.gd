extends Node2D

const IntroScene = preload("res://Characters/Levels/Intro/IntroScene.tscn")

signal next
# Called when the node enters the scene tree for the first time.
func _ready():
	$LogoAnimation.play("FannyFade")
	var fanny_fade_timeout = get_tree().create_timer(5.0).timeout
	fanny_fade_timeout.connect(self.show_next)
	await self.next
	fanny_fade_timeout.disconnect(self.show_next)
	$FannypackLogo.visible = false
	$SpikaGamesLogo.visible = true
	$LogoAnimation.play("SpikaFade")
	$AnimationPlayer.play("Blackout")
	var spika_fade_timeout = get_tree().create_timer(4.0).timeout
	spika_fade_timeout.connect(self.show_next)
	await self.next
	spika_fade_timeout.disconnect(self.show_next)	
	$SpikaGamesLogo.visible = false
	$AnimationPlayer.play("Fade Out")
	await self.next
	get_tree().change_scene_to_packed(IntroScene)


func _input(event):
	if(event.is_action_pressed("ui_accept")):
		get_viewport().set_input_as_handled()
		show_next()

func show_next():
	next.emit()
