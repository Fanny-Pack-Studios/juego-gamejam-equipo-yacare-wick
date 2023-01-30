class_name Asteroid
extends CharacterBody2D

@export var config: AsteroidConfig

var current_health := 10.0
var max_health := 10.0

signal removed(asteroid)

func asteroid_points():
	return scale.x

func _ready():
	var speed = _randf_bounds(config.speed_bounds)
	rotation = _randf_bounds(config.angle_bounds_degrees)
	velocity = (Vector2.UP * speed).rotated(rotation)
	var size = _randf_bounds(config.scale_bounds)
	scale = Vector2.ONE * size
	global_transform.origin.x = randf_range(
		config.origin_bounds.x,
		get_viewport_rect().end.x * config.origin_bounds.y
	)
	max_health = size * 100
	current_health = max_health

func _process(delta):
	var health_percentage = current_health / max_health
	$Polygon2D.modulate = Color(health_percentage,
								health_percentage,
								health_percentage)


func _physics_process(delta):
	move_and_slide()


func _randf_bounds(bounds: Vector2):
	return randf_range(bounds.x, bounds.y)

func _on_visible_on_screen_notifier_2d_screen_exited():
	remove()

func vanish():
	remove()

func hit_with_spaceship(_spaceship):
	vanish()

func be_damaged(amount):
	current_health -= amount
	if(current_health <= 0):
		vanish()

func remove():
	removed.emit(self)
	queue_free()
