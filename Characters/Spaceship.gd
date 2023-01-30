class_name Spaceship
extends CharacterBody2D

const Shoot = preload("res://Characters/Weapons/RegularShoot.tscn")

@export var MAX_SPEED := 300.0
@export var ACCELERATION := 15.0
@export var DRIFT_DESACCELERATION := 2.0
var current_health := 100.0

func _physics_process(delta):
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var target_speed := direction * MAX_SPEED
	velocity = velocity.move_toward(
		target_speed,
		DRIFT_DESACCELERATION if(target_speed.is_zero_approx()) else ACCELERATION
	)

	move_and_slide()


func _on_hitbox_body_entered(body):
	take_damage(10)
	body.hit_with_spaceship(self)


func take_damage(damage: float):
	current_health -= damage


func _on_weapon_timer_timeout():
	shoot()

func shoot():
	var shoot = Shoot.instantiate()
	shoot.speed = 1000
	add_child(shoot)
	shoot.global_transform.origin = global_transform.origin

