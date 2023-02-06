class_name Weapon
extends Power

enum Side { Left, Right, Any }

const Shoot = preload("res://Characters/Weapons/Shoot.tscn") 
@export var weapon_config: WeaponConfig

var side: Side = Side.Any

func cooldown_wait_time():
	return $SpecialAbilityCooldown.wait_time

func time_left_to_cooldown():
	return $SpecialAbilityCooldown.time_left

func bb_text():
	return "Fire rate: " + String.num(fire_rate(), 2) + "\n"\
			+ "Damage per shot: " + String.num(weapon_config.fire_power, 2)

func _physics_process(delta):
	if(player_used_it and $SpecialAbilityCooldown.is_stopped()):
		$SpecialAbilityCooldown.start()
		var dup_weapon = self.duplicate()
		target.add_child(dup_weapon)
		var dup_weapon_config = weapon_config.duplicate()
		dup_weapon.weapon_config = dup_weapon_config
		if(is_laser()):
			dup_weapon.global_transform.origin = target.global_transform.origin
			create_tween().tween_property(dup_weapon, "rotation_degrees", 360.0, 2).from(0.0).finished.connect(
				func(): dup_weapon.queue_free()
			)
		else:
			dup_weapon.global_transform.origin = self.global_transform.origin
			for i in range(1, 36):
				dup_weapon.rotation_degrees = i * 10
				dup_weapon.shoot()
			dup_weapon.queue_free()
		

func _ready():
	$Cooldown.wait_time = 1.0 / weapon_config.shoots_per_second
	$Cooldown.timeout.connect(self.shoot)
	$Cooldown.start()

func fire_rate():
	return weapon_config.shoots_per_second * (1 + pilot.reflexes())

func is_laser():
	return weapon_config.is_attached_to_parent

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
	if(is_laser()):
		add_child(shoot)
	else:
		get_parent().add_child(shoot)
	shoot.set_initial_position(global_transform.origin)
