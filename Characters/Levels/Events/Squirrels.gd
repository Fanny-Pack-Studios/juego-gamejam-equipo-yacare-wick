class_name Squirrels
extends Event

const MechaSquirrel = preload("res://Characters/Enemies/mecha_squirrel.tscn")

func start(level: Node2D):
	create_tween().set_loops(intensity).tween_callback(func():
		var squirrel = MechaSquirrel.instantiate()
		level.add_child(squirrel)
		squirrel.global_transform.origin = Vector2(
			ProjectSettings.get_setting("display/window/size/viewport_width") * randf_range(0.3, 0.7),
			ProjectSettings.get_setting("display/window/size/viewport_height")) - Vector2(0, level.global_transform.origin.y)
	).set_delay(5.0 / intensity)

