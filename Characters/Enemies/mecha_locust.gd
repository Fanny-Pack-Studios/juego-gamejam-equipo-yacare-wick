class_name MechaLocust
extends CharacterBody2D

var target: Node2D
@export var acceleration: float = 250
@export var max_speed: float = 250

func _ready():
	top_level = true

func _physics_process(delta):
	if(null == target):
		return
		
	var direction_to_target = global_transform.origin.direction_to(target.global_transform.origin)
	var target_velocity = direction_to_target * max_speed
	velocity = velocity.move_toward(target_velocity, delta * acceleration)

	move_and_slide()

func be_damaged(damage):
	pass
