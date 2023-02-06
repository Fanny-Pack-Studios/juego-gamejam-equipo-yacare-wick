@tool
class_name DestroyedEffect
extends Node2D
const ExplosionScene = preload("res://Effects/explosion.tscn")
const SmokeScene = preload("res://Effects/smoke.tscn")
@export var explosion_scale: float = 1.0
@export var explosion_time: float = 0.2
@export var stretch: Vector2 = Vector2(4, 0.1)

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
	target.set_physics_process(false)
	var time = explosion_time
	var tween = create_tween()
	var explosion_scene = ExplosionScene.instantiate()
	explosion_scene.scale = Vector2(explosion_scale, explosion_scale)
	target.get_parent().add_child(explosion_scene)
	explosion_scene.global_position = target.global_position
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
		stretch,
		time
	)
	tween.parallel().tween_property(
		target,
		"rotation",
		randf() * PI,
		time
	)
	tween.parallel().tween_callback(func(): target.queue_free()).set_delay(time)
