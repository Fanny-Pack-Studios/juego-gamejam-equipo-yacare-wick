extends Node2D

const SmokeScene = preload("res://Effects/smoke.tscn")

func _ready():
	$AnimatedSprite2D.animation_looped.connect(func():
		var smoke_scene = SmokeScene.instantiate()
		get_parent().add_child(smoke_scene)
		smoke_scene.global_position = global_position
		smoke_scene.scale = scale
		self.queue_free()
	)
	
