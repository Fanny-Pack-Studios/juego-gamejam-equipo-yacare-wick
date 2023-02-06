class_name Squirrels
extends Event

const MechaSquirrel = preload("res://Characters/Enemies/mecha_squirrel.tscn")

func start(level: Node2D):
	for i in range(1, intensity):
		var squirrel = MechaSquirrel.instantiate()
		level.add_child(squirrel)
		squirrel.global_transform.origin = Vector2(
			ProjectSettings.get_setting("display/window/size/viewport_width") * randf_range(0.3, 0.7),
			ProjectSettings.get_setting("display/window/size/viewport_height")) - Vector2(0, level.global_transform.origin.y)
		await get_tree().create_timer(1.0).timeout
