class_name Pilot
extends Object

const Weapon = preload("res://Characters/Weapons/Weapon.tscn")

var _defense: float
var _driving_skill: float
var _reflexes: float
var _age: int
var photo: Texture2D
var name: String
var biography: String
var power_scene
var _power
var instructors = []
var has_piloted_before = false

func power():
	if(not is_instance_valid(_power)):
		_power = power_scene.instantiate()
		_power.be_configured_by_pilot(self)
	return _power

static func random():
	var possible_names = []
	var possible_biographies = []
	
	var file = FileAccess.open(
		"res://assets/pilots.csv",
		FileAccess.READ
	)
	file.get_csv_line() # ignore headers
	while !file.eof_reached():
		var csv = file.get_csv_line()
		possible_names.append(csv[0])
		possible_biographies.append(csv[4])
	
	var pilot = Pilot.new()
	var possible_powers = [
		load("res://Characters/Powers/Shield.tscn"),
		load("res://Characters/Powers/Dash.tscn"),
		load("res://Characters/Powers/LaserWeapon.tscn"),
		load("res://Characters/Powers/RegularWeapon.tscn"),
		load("res://Characters/Powers/BombWeapon.tscn")
	]
	pilot.power_scene = possible_powers.pick_random()
	var possible_configs = [
		load("res://Parameters/Weapons/bomb_shoot.tres"),
		load("res://Parameters/Weapons/laser_shoot.tres"),
		load("res://Parameters/Weapons/regular_shoot.tres")
	]
	var PILOTS_PHOTO_DIR = "res://assets/Pilotos/"
	var photo_path = PILOTS_PHOTO_DIR + (
		Array(DirAccess.open(PILOTS_PHOTO_DIR)\
			.get_files())\
			.map(func(filepath: String): return filepath.replace(".import", ""))\
			.pick_random()
	)
	pilot.photo = load(photo_path)
	var random_pilot_idx = randi_range(0, possible_names.size() - 1)
	pilot.name = possible_names[random_pilot_idx]
	pilot.biography = possible_biographies[random_pilot_idx]
	pilot._defense = randf_range(0.0, 5.0)
	pilot._driving_skill = randf_range(0.0, 1.0)
	pilot._reflexes = randf_range(0.0, 1.0)
	pilot._age = randi_range(18, 40)
#	pilot.weapon = pilot.weapon_from_config(possible_configs.pick_random())

	return pilot

func bonus_from_instructors(stat):
	return instructors.map(func(instructor): instructor.bonus_stat("defense")).reduce(add, 0)

func add(a, b):
	return a + b

func bonus_stat(stat):
	if(stat == best_skill().back()):
		return best_skill().front() * 0.15
	else:
		return 0.0

func bonus_text(str: String):
	return str("[color=green]", str, "[/color]\n")

func best_skill() -> Array:
	return [[_defense / 5.0, "defense"], [_driving_skill, "driving_skill"], [_reflexes,"reflexes"]].max()

func inherited_stats_description():
	match best_skill().back():
		"defense":
			return str("Next recruits will have ", bonus_text("+%" + String.num(_defense / 5.0 * 10.0, 2)), " ship defenses")
	match best_skill:
		"driving_skill":
			return str("Next recruits will have ", bonus_text("+%" + String.num(_driving_skill * 10.0, 2)), " ship speed")
	match best_skill:
		"reflexes":
			return str("Next recruits will have ", bonus_text("less cooldown on abilities"))

func stats_description():
	var description = str("Age: ", _age, "\n\n")
	if(defense() > 0.0):
		description += bonus_text(str("Ship defense: +", String.num(defense(), 2)))
	if(driving_skill() > 0.1):
		description += bonus_text(str("Ship speed: +", round(driving_skill() * 100.0)))
	description += power().bb_text()
	return description

func bonus_from_experience():
	return 1.5 if has_piloted_before else 1.0

func defense():
	return (_defense + bonus_from_instructors("defense")) * bonus_from_experience()

func driving_skill():
	return (_driving_skill + bonus_from_instructors("driving_skill")) * bonus_from_experience()

func reflexes():
	return (_reflexes + bonus_from_instructors("reflexes")) * bonus_from_experience()

# TODO: esto por ahora es random pero la idea seria que al generarse el piloto
# se definan que armas va a usar
func weapons() -> Array:
	var possible_configs = [
		load("res://Parameters/Weapons/regular_shoot.tres")
	]
	
	return [
		possible_configs.pick_random(),
		possible_configs.pick_random()
	].map(
		func(config): return weapon_from_config(config)
	)

func weapon_from_config(config: WeaponConfig):
	var weapon = Weapon.instantiate()
	weapon.weapon_config = config
	return weapon
