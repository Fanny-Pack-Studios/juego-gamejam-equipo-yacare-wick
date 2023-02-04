extends Node3D

var using_shield = false

var shield_material

func _ready():
	shield_material = $Test_FX/shield/shield2.get_surface_override_material(0)

func _process(delta):
	var shield_alpha = shield_material.get_shader_parameter("shield_alpha")
	if(using_shield):
		shield_alpha = move_toward(shield_alpha, 1.0, delta)
		shield_material.set_shader_parameter("shield_alpha", shield_alpha)
	else:
		shield_alpha = move_toward(shield_alpha, 0.0, delta * 10)
		shield_material.set_shader_parameter("shield_alpha", shield_alpha)

func hovering():
	var tween = create_tween().set_loops()
	tween.tween_property($Camera3D, "position:z", 1.5, 5).set_ease(Tween.EASE_IN_OUT).as_relative()
	tween.tween_property($Camera3D, "position:z", -1.5, 5).set_ease(Tween.EASE_IN_OUT).as_relative()
