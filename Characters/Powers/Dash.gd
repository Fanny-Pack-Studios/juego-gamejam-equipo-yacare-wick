extends Power

@export var dash_time: float = 0.5
@export var _cooldown_time: float = 2.0
@export var _speed_bonus: float = 400
@export var _damage: float = 50
@export var _uses: int = 1
var internal_cooldown_between_uses = dash_time / 1.8
var uses_left: int

func cooldown_time():
	return _cooldown_time * (1.5 - pilot.reflexes())

func speed_bonus():
	return _speed_bonus + 300 * pilot.driving_skill()

func damage():
	return _damage * (5 * pilot.driving_skill())

func uses():
	return _uses + round(3 * pilot.reflexes())

func _ready():
	internal_cooldown_between_uses = dash_time / 1.8
	uses_left = uses()
	$DashTime.wait_time = dash_time
	$InternalCooldown.wait_time = internal_cooldown_between_uses
	$Area.body_entered.connect(func(body):
		if(body):
			body.be_damaged(damage())
	)

func recover_use():
	uses_left = min(uses_left + 1, uses())

func cooldown_wait_time():
	return cooldown_time()

func time_left_to_cooldown():
	if(uses_left > 0):
		return 0
	else:
		return cooldown_wait_time()

func _physics_process(delta):
	var is_active = not $DashTime.is_stopped()
	if(uses_left > 0 and player_used_it and $InternalCooldown.is_stopped()):
		uses_left -= 1
		target.protections.push_back(self)
		$DashTime.start()
		$InternalCooldown.start()
		create_tween().tween_callback(self.recover_use).set_delay(cooldown_time())
		var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		create_tween().tween_property(
			target,
			"velocity",
			direction * (target.max_speed() + speed_bonus()),
			dash_time / 2
		).set_trans(Tween.TRANS_BACK)
		var shadow_count = $Shadows.get_children().size()
		create_tween().set_loops(8).tween_callback(self.place_shadow).set_delay(dash_time / shadow_count)

	if(is_active and not self in target.protections):
		target.protections.push_back(self)
	if(not is_active and self in target.protections):
		target.protections.erase(self)

	$Area.monitoring = is_active

func place_shadow():
	var shadow = $Shadows.get_children().filter(func(shadow): return not shadow.visible).front()
	if(shadow):
		shadow.modulate = Color.AQUA
		shadow.modulate.a = 0.7
		shadow.top_level = true
		shadow.pivot_offset = -shadow.size / 2 
		shadow.position = target.global_transform.origin
		shadow.visible = true
		await create_tween().tween_property(shadow, "modulate:a", 0, 0.2).finished
		shadow.visible = false

func bb_text():
	return "Dash speed: " + String.num(speed_bonus(), 0) + "\n" +\
			"Cooldown: " + String.num(cooldown_time(), 2) + "\n" +\
			"Dash damage: " + String.num(damage(), 2) + "\n" +\
			"Uses in a row: " + str(uses())
