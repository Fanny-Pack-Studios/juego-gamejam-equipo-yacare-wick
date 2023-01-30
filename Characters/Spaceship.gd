class_name Spaceship
extends CharacterBody2D


@export var MAX_SPEED := 300.0
@export var ACCELERATION := 15.0
@export var DRIFT_DESACCELERATION := 2.0

func _physics_process(delta):
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var target_speed := direction * MAX_SPEED
	velocity = velocity.move_toward(
		target_speed,
		DRIFT_DESACCELERATION if(target_speed.is_zero_approx()) else ACCELERATION
	)

	move_and_slide()
