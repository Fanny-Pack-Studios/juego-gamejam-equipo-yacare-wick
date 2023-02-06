extends Node2D

func _ready():
	rotation_degrees = randi_range(0, 359)
	create_tween().tween_property($AnimatedSprite2D, "scale", Vector2(2.0, 2.0), 0.3).set_trans(Tween.TRANS_BOUNCE)
	await create_tween().tween_property($AnimatedSprite2D, "modulate:a", 0, 0.3).finished
	queue_free()
