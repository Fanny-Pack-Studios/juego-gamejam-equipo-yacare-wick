class_name Asteroid
extends CharacterBody2D

@export var config: AsteroidConfig

var current_health := 10.0
var max_health := 10.0

@export var too_little_threshold := 0.5
@onready var sound = $AudioStreamPlayer2D

signal removed(asteroid)
signal destroyed(asteroid)

func config_type():
	return load("res://Characters/AsteroidConfig.tres")

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
	rotation_degrees = rotation
	max_health = size * 100
	current_health = max_health

func _process(delta):
	var health_percentage = current_health / max_health
	$Sprite2D.modulate = Color(health_percentage,
								health_percentage,
								health_percentage)
	rotation_degrees += delta * velocity.cross(Vector2.UP) / 5

func is_too_little():
	return scale.x < too_little_threshold

func _physics_process(delta):
	move_and_slide()


func _randf_bounds(bounds: Vector2):
	return randf_range(bounds.x, bounds.y)

func _on_visible_on_screen_notifier_2d_screen_exited():
	remove()

func hit_with_spaceship(spaceship: Spaceship):
	spaceship.take_damage(10)
	destroy()

func destroy():
	destroyed.emit(self)
	remove()

func be_damaged(amount):
	current_health -= amount
	sound.play()
	if(current_health <= 0):
		destroy()

func remove():
	removed.emit(self)
	queue_free()
