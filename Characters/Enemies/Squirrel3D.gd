extends Node3D

func _ready():
	var tween = create_tween().set_loops()
	tween.tween_property($SirenLight, "light_energy", 30.0, 0.3)
	tween.tween_property($SirenLight, "light_energy", 1.0, 0.3)
	var rotation_tween = create_tween().set_loops()
	rotation_tween.tween_property($ardini, "rotation_degrees:z", 30, 3)
	rotation_tween.tween_property($ardini, "rotation_degrees:z", -30, 3)
	var rotation_x_tween = create_tween().set_loops()
	rotation_x_tween.tween_property($ardini, "rotation_degrees:x", -15, 2)
	rotation_x_tween.tween_property($ardini, "rotation_degrees:x", 0, 2)

func play_attack_animation():
	$ardini/AnimationPlayer.speed_scale = 2.5
	$ardini/AnimationPlayer.play("atk_mode")
