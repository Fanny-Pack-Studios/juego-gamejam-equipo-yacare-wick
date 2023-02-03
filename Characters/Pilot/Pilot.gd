class_name Pilot
extends Node

const Weapon = preload("res://Characters/Weapons/Weapon.tscn")


# TODO: esto por ahora es random pero la idea seria que al generarse el piloto
# se definan que armas va a usar
func weapons() -> Array[Weapon]:
	var possible_configs = [
		load("res://Parameters/Weapons/bomb_shoot.tres"),
		load("res://Parameters/Weapons/laser_shoot.tres"),
		load("res://Parameters/Weapons/regular_shoot.tres")
	]
	
	return [
		possible_configs.pick_random(),
		possible_configs.pick_random()
	].map(
		func(config): return weapon_from_config(config)
	)

func weapon_from_config(config: WeaponConfig) -> Weapon:
	var weapon = Weapon.instantiate()
	weapon.weapon_config = config
	return weapon
