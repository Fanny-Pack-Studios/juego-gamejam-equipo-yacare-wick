class_name Pilot
extends RefCounted

const Weapon = preload("res://Characters/Weapons/Weapon.tscn")

var _defense: float
var _driving_skill: float
var photo: Texture2D
var name: String
var biography: String
var weapon: Weapon

static func random():
	var possible_names = []
	var possible_biographies = []
	
	var file = FileAccess.open(
		"res://assets/Radix Pilots - Pilots.csv",
		FileAccess.READ
	)
	file.get_csv_line() # ignore headers
	while !file.eof_reached():
		var csv = file.get_csv_line()
		possible_names.append(csv[0])
		possible_biographies.append(csv[4])
	
	var pilot = Pilot.new()
	var possible_configs = [
		load("res://Parameters/Weapons/bomb_shoot.tres"),
		load("res://Parameters/Weapons/laser_shoot.tres"),
		load("res://Parameters/Weapons/regular_shoot.tres")
	]
	var PILOTS_PHOTO_DIR = "res://assets/Pilotos/"
	var photo_path = PILOTS_PHOTO_DIR + (
		Array(DirAccess.open(PILOTS_PHOTO_DIR)\
			.get_files())\
			.filter(func(filepath): return ("candidate" in filepath and not ".import" in filepath))\
			.pick_random()
	)
	pilot.photo = load(photo_path)
	var random_pilot_idx = randi_range(0, possible_names.size())
	pilot.name = possible_names[random_pilot_idx]
	pilot.biography = possible_biographies[random_pilot_idx]
	pilot.weapon = pilot.weapon_from_config(possible_configs.pick_random())

	return pilot


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
