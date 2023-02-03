class_name Spaceship
extends CharacterBody2D

const Weapon = preload("res://Characters/Weapons/weapon.gd")

@export var BASE_MAX_SPEED := 200.0
@export var BASE_ACCELERATION := 15.0
@export var BASE_DRIFT_DESACCELERATION := 2.0
@export var model_rotation_speed := 70.0
@export var base_defense := 1
@onready var spaceship_3d: Node3D = $SubViewportContainer/SubViewport/Spaceship3D/spaceship
var MAX_HEALTH := 100.0
var current_health := MAX_HEALTH
@export var invincible_time := 1.0
@onready var sound = $Sound
var protections = []

var pilot: Pilot
var copilot: Pilot

func defense():
	return 0

func max_speed() -> float:
	return BASE_MAX_SPEED * (1 + pilot.driving_skill() + copilot.driving_skill())

func acceleration() -> float:
	return BASE_ACCELERATION * (1 + pilot.driving_skill() + copilot.driving_skill())

func drift_desacceleration() -> float:
	return BASE_ACCELERATION * (1 + pilot.driving_skill() + copilot.driving_skill())

func be_boarded(_pilot: Pilot, _copilot: Pilot):
	pilot = _pilot
	copilot = _copilot
	equip_weapons(pilot.weapons())

func equip_weapons(weapons: Array):
	$Weapons.get_children().clear()
	weapons.map(func (weapon):
		match weapon.side:
			Weapon.Side.Left:
				$Weapons/Slots/LeftCannon.add_child(weapon)
			Weapon.Side.Right:
				$Weapons/Slots/RightCannon.add_child(weapon)
			Weapon.Side.Any:
				var slots := $Weapons/Slots.get_children()
				var chosen_slot = min_by(slots, func(slot): return slot.get_children().size())
				chosen_slot.add_child(weapon)
	)

func max_by(array: Array, callable: Callable) -> Variant:
	return array.reduce(
		func(x, y): return x if callable.call(x) < callable.call(y) else y,
		array.front()
	)

func min_by(array: Array, callable: Callable) -> Variant:
	return array.reduce(
		func(x, y): return x if callable.call(x) < callable.call(y) else y,
		array.front()
	)

func is_invincible() -> bool:
	return $InvincibleTimer.time_left > 0
	
func turned_violently() -> bool:
	return Input.is_action_just_pressed("ui_right") && Input.is_action_pressed("ui_left")
	
func zap_things() -> bool:
	return Input.is_action_pressed("ui_accept")
	
func should_blink() -> bool:
	return is_invincible() and Engine.get_frames_drawn() % 2 == 0

func _ready():
	if(null == pilot):
		pilot = Pilot.random()
	if(null == copilot):
		copilot = Pilot.random()
	$InvincibleTimer.wait_time = invincible_time
	top_level = true
	if(not $Powers/Primary.get_children().is_empty()):
		$Powers/Primary.get_children().front().target = self
	if(not $Powers/Secondary.get_children().is_empty()):
		$Powers/Secondary.get_children().front().target = self

func _physics_process(delta):
	$Hitbox.monitoring = not is_invincible()
	spaceship_3d.visible = not should_blink()

	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var target_speed := direction * max_speed()
	velocity = velocity.move_toward(
		target_speed,
		(drift_desacceleration() if(target_speed.is_zero_approx()) else acceleration())
	)
	var using_primary_power := Input.is_action_pressed("primary_action")
	if(not $Powers/Primary.get_children().is_empty()):
		$Powers/Primary.get_children().front().player_is_using_it = using_primary_power
	var using_secondary_power := Input.is_action_pressed("secondary_action")
	if(not $Powers/Secondary.get_children().is_empty()):
		$Powers/Secondary.get_children().front().player_is_using_it = using_secondary_power
	
	$Hitbox.monitoring = protections.is_empty()

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
	current_health -= abs(damage - defense())
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

