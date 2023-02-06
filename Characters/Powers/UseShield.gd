extends Power

@export var _shield_time: float = 5.0
@export var _cooldown_time: float = 10.0

func cooldown_wait_time():
	return $Cooldown.wait_time

func time_left_to_cooldown():
	return $Cooldown.time_left


func shield_time():
	return 1.0 + _shield_time * (pilot.defense() / 5.0)

func cooldown_time():
	return _cooldown_time - 5 * pilot.reflexes()

func _ready():
	$ShieldTime.wait_time = shield_time()
	$Cooldown.wait_time = cooldown_time()
	$ShieldTime.timeout.connect(func():
		target.protections.erase(self)
	)
	$Area.body_entered.connect(self.shield_from)

func shield_from(body):
	body.be_damaged(100)

func _physics_process(delta):
	var is_active = not $ShieldTime.is_stopped()
	if(not is_active and player_used_it and $Cooldown.is_stopped()):
		target.protections.push_back(self)
		$ShieldTime.start()
		$Cooldown.start()

	$Area.monitoring = is_active
	target.find_child("Spaceship3D", true).using_shield = is_active
	target.destroy_attached()

func bb_text():
	return "Shield time: " + String.num(shield_time(), 2)+ "s\n" +\
			"Cooldown: " + String.num(cooldown_time(), 2) + "s\n"
