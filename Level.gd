class_name Level
extends Node2D

@export var beginning: Node2D
@export var end: Node2D
@export var travel_speed: float = 1.0
var distance_traveled: float = 0

func _ready():
	[$Walls, $Walls2].map(func (wall): wall.top_level = true)

func length():
	return beginning.global_transform.origin.distance_to(end.global_transform.origin)

func _physics_process(delta):
	global_transform.origin = global_transform.origin.move_toward(
		end_point(),
		delta * travel_speed
	)

func distance_left():
	return global_transform.origin.distance_to(end_point())

func end_point() -> Vector2:
	return beginning.global_transform.origin - end.global_transform.origin