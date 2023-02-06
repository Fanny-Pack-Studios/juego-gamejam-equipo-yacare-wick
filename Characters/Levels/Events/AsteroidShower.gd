class_name AsteroidShower
extends Event

@export var duration_in_seconds: float
var asteroid_config: AsteroidConfig
var AsteroidSpawner = preload("res://Characters/Enemies/asteroids_spawner.tscn")

func _ready():
	asteroid_config = load("res://Characters/Levels/Events/AsteroidShowerConfig.tres")

func start(level: Node2D):
	asteroid_config = asteroid_config.duplicate()
	asteroid_config.speed_bounds = Vector2(300, 400) + Vector2(50, 100) * (intensity / 20.0)
	var asteroid_spawner = AsteroidSpawner.instantiate()
	asteroid_spawner.asteroid_config = asteroid_config
	asteroid_spawner.max_asteroid_points_in_screen = intensity
	level.add_child(asteroid_spawner)
	asteroid_spawner.global_transform.origin = level.global_transform.origin + Vector2(0, ProjectSettings.get_setting("display/window/size/viewport_height"))
	asteroid_spawner.top_level = true
	get_tree().create_timer(5).timeout.connect(func():
		asteroid_spawner.enabled = false
		self.queue_free()
	)
	
