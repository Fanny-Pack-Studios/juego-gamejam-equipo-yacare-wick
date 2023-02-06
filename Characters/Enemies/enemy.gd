class_name Enemy
extends CharacterBody2D

@export var max_health: float = 100
var current_health
var moving_in_path = false

signal killed
signal was_hit(damage)

func _ready():
	current_health = max_health
	set_collision_layer_value(3, true)

func be_damaged(damage):
	was_hit.emit(damage)
	current_health -= damage
	if(current_health <= 0):
		_killed()
		killed.emit()
	
func _killed():
	pass

func set_moving_in_path(value):
	moving_in_path = value

func kill():
	_killed()
	killed.emit()
