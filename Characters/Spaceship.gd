class_name Spaceship
extends CharacterBody2D

const Shoot = preload("res://Characters/Weapons/RegularShoot.tscn")

@export var MAX_SPEED := 300.0
@export var ACCELERATION := 15.0
@export var DRIFT_DESACCELERATION := 2.0
var MAX_HEALTH := 100.0
var current_health := MAX_HEALTH
@export var invincible_time := 1.0

func is_invincible() -> bool:
	return $InvincibleTimer.time_left > 0

func should_blink() -> bool:
	return is_invincible() and Engine.get_frames_drawn() % 2 == 0

func _ready():
	$InvincibleTimer.wait_time = invincible_time
	top_level = true

func _physics_process(delta):
	$Hitbox.monitoring = not is_invincible()
	$Sprite.color.a = 0 if should_blink() else 1.0

	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var target_speed := direction * MAX_SPEED
	velocity = velocity.move_toward(
		target_speed,
		DRIFT_DESACCELERATION if(target_speed.is_zero_approx()) else ACCELERATION
	)

	move_and_slide()


func _on_hitbox_body_entered(body):
	body.hit_with_spaceship(self)

func start_invincibility():
	$InvincibleTimer.start()


func take_damage(damage: float, turn_on_invincibility: bool = true):
	current_health -= damage
	if(turn_on_invincibility):
		start_invincibility()

func random_attach_point() -> Vector2:
	var rect: Rect2i = $Hitbox/CollisionShape2D.shape.get_rect()
	var begin = rect.position
	var end = rect.end
	var x = randf_range(begin.x, end.x)
	var y = randf_range(begin.y, end.y)
	return Vector2(x, y)
