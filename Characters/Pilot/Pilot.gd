class_name Pilot
extends RefCounted

const Weapon = preload("res://Characters/Weapons/Weapon.tscn")

var _defense: float
var _driving_skill: float

func defense():
	return defense

func driving_skill():
	return _driving_skill

func _init():
	_defense = randf_range(0.0, 5.0)
	_driving_skill = randf_range(0.0, 1.0)

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
