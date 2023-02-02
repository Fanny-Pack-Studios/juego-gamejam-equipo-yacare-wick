class_name Spaceship
extends CharacterBody2D


@export var MAX_SPEED := 300.0
@export var ACCELERATION := 15.0
@export var model_rotation_speed := 70.0
@export var DRIFT_DESACCELERATION := 2.0
@onready var spaceship_3d: Node3D = $SubViewportContainer/SubViewport/spaceship
var MAX_HEALTH := 100.0
var current_health := MAX_HEALTH
@export var invincible_time := 1.0
@onready var sound = $Sound

func is_invincible() -> bool:
	return $InvincibleTimer.time_left > 0
	
func turned_violently() -> bool:
	return Input.is_action_just_pressed("ui_right") && Input.is_action_pressed("ui_left")
	
func zap_things() -> bool:
	return Input.is_action_pressed("ui_accept")
	
func should_blink() -> bool:
	return is_invincible() and Engine.get_frames_drawn() % 2 == 0

func _ready():
	$InvincibleTimer.wait_time = invincible_time
	top_level = true

func _physics_process(delta):
	$Hitbox.monitoring = not is_invincible()
	spaceship_3d.visible = not should_blink()

	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var target_speed := direction * MAX_SPEED
	velocity = velocity.move_toward(
		target_speed,
		DRIFT_DESACCELERATION if(target_speed.is_zero_approx()) else ACCELERATION
	)

	spaceship_3d.rotation_degrees.z = move_toward(
		spaceship_3d.rotation_degrees.z,
		Input.get_axis("ui_left", "ui_right") * 30,
		model_rotation_speed * delta
	)

	move_and_slide()


func _on_hitbox_body_entered(body):
	body.hit_with_spaceship(self)
	sound.play()
	

func _on_hitbox_area_entered(area):
	_on_hitbox_body_entered(area.get_parent())

func start_invincibility():
	$InvincibleTimer.start()


func take_damage(damage: float, turn_on_invincibility: bool = true):
	current_health -= damage
	var max_shake = 2
	$Shaker.max_value = max(damage / 10.0, max_shake)
	$Shaker.start(0.5)
	if(turn_on_invincibility):
		start_invincibility()

func random_attach_point() -> Vector2:
	var rect: Rect2i = $Hitbox/CollisionShape2D.shape.get_rect()
	var begin = rect.position
	var end = rect.end
	var x = randf_range(begin.x, end.x)
	var y = randf_range(begin.y, end.y)
	return Vector2(x, y)

