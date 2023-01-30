class_name Asteroid
extends CharacterBody2D
#
@export var speed_bounds := Vector2(300.0, 400.0)
@export var angle_bounds_degrees := Vector2(0, 360)
@export var scale_bounds := Vector2(0.33, 1.0)

signal removed(asteroid)

func asteroid_points():
	return scale.x

func _ready():
	var speed = _randf_bounds(speed_bounds)
	rotation = _randf_bounds(angle_bounds_degrees)
	velocity = (Vector2.UP * speed).rotated(rotation)
	var size = _randf_bounds(scale_bounds)
	scale = Vector2.ONE * size

func _physics_process(delta):
	move_and_slide()

func _randf_bounds(bounds: Vector2):
	return randf_range(bounds.x, bounds.y)

func _on_visible_on_screen_notifier_2d_screen_exited():
	remove()

func vanish():
	remove()

func remove():
	removed.emit(self)
	queue_free()
