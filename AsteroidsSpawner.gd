extends Node2D

@export var time_between_spawns_bounds := Vector2(0.5, 1.5)
const Asteroid = preload("res://Characters/Asteroid.tscn")
# Un asteroide grande ocupa mas puntos que un asteroide chico
@export var max_asteroid_points_in_screen = 2
var current_asteroid_points_in_screen = 0

@export var asteroid_config: AsteroidConfig

func _ready():
	spawn_asteroid_process()

func spawn_asteroid_process():
	var time_to_spawn = randf_range(
		time_between_spawns_bounds.x,
		time_between_spawns_bounds.y
	)
	await get_tree().create_timer(time_to_spawn, false, true).timeout

	if(current_asteroid_points_in_screen < max_asteroid_points_in_screen):
		spawn_asteroid()
	
	call_deferred("spawn_asteroid_process")

func spawn_asteroid():
	var asteroid := Asteroid.instantiate()
	asteroid.config = asteroid_config
	add_child(asteroid)
	current_asteroid_points_in_screen += asteroid.asteroid_points()
	asteroid.removed.connect(self.asteroid_removed)


func asteroid_removed(asteroid):
	current_asteroid_points_in_screen -= asteroid.asteroid_points()

func _physics_process(delta):
	pass
