extends Node2D

@onready var fanny = preload("res://Characters/Levels/Titlescreen/SquareLogoFanny.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	$LogoAnimation.play("FannyFade")
	await get_tree().create_timer(5.0).timeout
	$AnimationPlayer.play("Blackout")
	$LogoAnimation.play("SpikaFade")
	await get_tree().create_timer(4.0).timeout
	$AnimationPlayer.play("Fade Out")
	await get_tree().create_timer(4.0).timeout
	$AnimationPlayer.play("Fade In")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
