class_name Enemy
extends CharacterBody2D

@export var max_health: float = 100
var current_health = max_health

signal killed
signal was_hit(damage)

func be_damaged(damage):
	set_deferred("collision_layer", 0)
	was_hit.emit(damage)
	current_health -= damage
	if(current_health <= 0):
		killed.emit()
	
