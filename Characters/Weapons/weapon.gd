extends Node2D

const Shoot = preload("res://Characters/Weapons/Shoot.tscn") 
@export var weapon_config: WeaponConfig

func _ready():
	$Cooldown.wait_time = 1.0 / weapon_config.shoots_per_second
	$Cooldown.timeout.connect(self.shoot)
	$Cooldown.start()

func shoot():
	var shoot = Shoot.instantiate()

	var shoot_direction = global_transform.origin.direction_to(
		$ShootDirection.to_global($ShootDirection.target_position)
	)
	shoot.velocity = shoot_direction * weapon_config.shoot_speed
	shoot.set_sprite(weapon_config.sprite)
	shoot.top_level = not weapon_config.is_attached_to_parent
	shoot.fire_power = weapon_config.fire_power
	shoot.time_to_live_in_seconds = weapon_config.shoot_time_to_live_in_seconds
	shoot.goes_through_enemies = weapon_config.shoot_goes_through_enemies
	shoot.range_in_meters = weapon_config.range_in_meters
	add_child(shoot)
	shoot.set_initial_position(global_transform.origin)
