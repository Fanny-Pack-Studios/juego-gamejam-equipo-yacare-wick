extends Power

@export var shield_time: float = 5.0
@export var cooldown_time: float = 10.0

func _ready():
	$ShieldTime.wait_time = shield_time
	$Cooldown.wait_time = cooldown_time
	$ShieldTime.timeout.connect(func():
		target.protections.erase(self)
	)
	$Area.body_entered.connect(self.shield_from)

func shield_from(body):
	body.be_damaged(100)

func _physics_process(delta):
	var is_active = not $ShieldTime.is_stopped()
	if(not is_active and player_is_using_it and $Cooldown.is_stopped()):
		target.protections.push_back(self)
		$ShieldTime.start()
		$Cooldown.start()

	$Area.monitoring = is_active
	target.find_child("Spaceship3D", true).using_shield = is_active
