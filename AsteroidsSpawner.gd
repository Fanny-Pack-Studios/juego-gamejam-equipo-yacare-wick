extends Node2D

@export var time_between_spawns_bounds := Vector2(0.5, 1.5)
const Asteroid = preload("res://Characters/Asteroid.tscn")
# Un asteroide grande ocupa mas puntos que un asteroide chico
@export var max_asteroid_points_in_screen := 2.0
var current_asteroids_in_screen: Array[Asteroid] = []

@export var asteroid_config: AsteroidConfig

var enabled = false

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

	if(enabled and current_asteroid_points_in_screen() < max_asteroid_points_in_screen):
		spawn_asteroid()
	
	call_deferred("spawn_asteroid_process")

func spawn_asteroid(config = asteroid_config) -> Asteroid:
	var asteroid := Asteroid.instantiate()
	asteroid.config = config
	get_node("/root").add_child(asteroid)
	asteroid.global_transform.origin.y = global_transform.origin.y
	current_asteroids_in_screen.push_back(asteroid)
	asteroid.removed.connect(self.asteroid_removed)
	asteroid.destroyed.connect(self.asteroid_destroyed)
	return asteroid


func asteroid_removed(asteroid):
	current_asteroids_in_screen.erase(asteroid)

func asteroid_destroyed(asteroid):
	if(not asteroid.is_too_little()):
		call_deferred("spawn_asteroid_fragment", asteroid.global_transform.origin, asteroid.scale / 2)
		call_deferred("spawn_asteroid_fragment", asteroid.global_transform.origin, asteroid.scale / 2)


func spawn_asteroid_fragment(position, scale):
	var new_asteroid := spawn_asteroid(load("res://Characters/FragmentConfig.tres"))
	new_asteroid.global_transform.origin = position
	new_asteroid.scale = scale



func _on_disable_if_spawner_is_on_screen_screen_entered():
	enabled = false


func _on_visible_on_screen_enabler_2d_screen_entered():
	enabled = true
