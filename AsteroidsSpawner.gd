extends Node2D

@export var time_between_spawns_bounds := Vector2(0.5, 1.5)
const Asteroid = preload("res://Characters/Asteroid.tscn")
# Un asteroide grande ocupa mas puntos que un asteroide chico
@export var max_asteroid_points_in_screen = 2
var current_asteroids_in_screen: Array[Asteroid] = []

@export var asteroid_config: AsteroidConfig

func sum(accum, number) -> float:
	return accum + number

func current_asteroid_points_in_screen() -> float:
	return current_asteroids_in_screen\
			.map(func(asteroid): return asteroid.asteroid_points())\
			.reduce(sum, 0)


func _ready():
	spawn_asteroid_process()


func spawn_asteroid_process():
	var time_to_spawn = randf_range(
		time_between_spawns_bounds.x,
		time_between_spawns_bounds.y
	)
	await get_tree().create_timer(time_to_spawn, false, true).timeout

	if(current_asteroid_points_in_screen() < max_asteroid_points_in_screen):
		spawn_asteroid()
	
	call_deferred("spawn_asteroid_process")

func spawn_asteroid():
	var asteroid := Asteroid.instantiate()
	asteroid.config = asteroid_config
	add_child(asteroid)
	current_asteroids_in_screen.push_back(asteroid)
	asteroid.removed.connect(self.asteroid_removed)
	return asteroid


func asteroid_removed(asteroid):
	current_asteroids_in_screen.erase(asteroid)
	if(not asteroid.is_too_little()):
		call_deferred("spawn_asteroid_fragment", asteroid.global_transform.origin, asteroid.scale / 2)
		call_deferred("spawn_asteroid_fragment", asteroid.global_transform.origin, asteroid.scale / 2)


func spawn_asteroid_fragment(position, scale):
	var new_asteroids := [spawn_asteroid(), spawn_asteroid()]
	new_asteroids.map(func (new_asteroid):
		new_asteroid.global_transform.origin = position
		new_asteroid.scale = scale / 2
	)

func _physics_process(delta):
	pass
