class_name Lochusts
extends Event

const MechaLochustSpawner = preload("res://Characters/Enemies/mecha_locust_spawner.tscn")

func start(level: Node2D):
	create_tween().set_loops(intensity).tween_callback(func():
		var lochust_spawner = MechaLochustSpawner.instantiate()
		lochust_spawner.target_spaceship = level.find_child("Spaceship", true)
		level.add_child(lochust_spawner)
		lochust_spawner.global_transform.origin = Vector2(
			ProjectSettings.get_setting("display/window/size/viewport_width") * randf_range(0.3, 0.7),
			ProjectSettings.get_setting("display/window/size/viewport_height")) - Vector2(0, level.global_transform.origin.y)
	).set_delay(2.0)
