extends Control

@export var level: Node2D
@onready var slider = $VSlider

func _physics_process(delta):
	slider.max_value = level.length()
	slider.value = level.distance_left()
