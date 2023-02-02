@tool
class_name DestroyedEffect
extends Node2D

var target: CharacterBody2D

func _get_configuration_warnings():
	var warnings = []
	if(not get_parent()):
		return warnings
	if(not get_parent().has_signal("killed")):
		warnings.push_back("Parent should emit signal killed")
	if(not get_parent().has_method("sprites")):
		warnings.push_back("Parent should have a sprites method")
	return warnings

func _ready():
	if Engine.is_editor_hint():
		return
	target = get_parent()
	target.killed.connect(self.explode)

func explode():
	var time = 0.2
	var tween = create_tween()
	target.sprites().map(func(sprite):
		tween.parallel().tween_property(
		sprite,
		"color",
		Color.WHITE,
		time
	)
	)
	tween.parallel().tween_property(
		target,
		"scale",
		Vector2(4, 0.1),
		time
	)
	tween.parallel().tween_property(
		target,
		"rotation",
		randf() * PI,
		time
	)
	tween.parallel().tween_callback(func(): target.queue_free()).set_delay(time)
