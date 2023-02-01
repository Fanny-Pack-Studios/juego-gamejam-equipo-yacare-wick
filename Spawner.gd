extends Node2D

const MechaLocust = preload("res://Characters/Enemies/mecha_locust.tscn")

@export var target_spaceship: Spaceship

func spawn_swarm():
	for i in range(10):
		var x = randf_range(-1, 1)
		var y = randf_range(-1, 1)
		spawn_lochust(Vector2(x, y))
		
func spawn_lochust(relative_position):
	var lochust = MechaLocust.instantiate()
	lochust.transform.origin = global_transform.origin + relative_position
	lochust.target = target_spaceship
	call_deferred("add_child", lochust)
	
	


func _on_area_2d_body_entered(body):
	spawn_swarm()
