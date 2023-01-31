extends Control

@export var level: Node2D
@onready var slider = $VSlider

func _ready():
	slider.max_value = level.length()

func _physics_process(delta):
	slider.value = level.distance_left()
