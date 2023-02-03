extends Node2D

var player_is_using_it: bool = false
var target: Spaceship
@export var dash_time: float = 0.5
@export var cooldown_time: float = 2.0
@export var speed_bonus: float = 300
@export var damage: float = 50
@export var uses: int = 3
var internal_cooldown_between_uses = dash_time / 1.5
var uses_left: int = uses


func _ready():
	internal_cooldown_between_uses = dash_time / 1.5
	uses_left = uses
	$DashTime.wait_time = dash_time
	$InternalCooldown.wait_time = internal_cooldown_between_uses
	$DashTime.timeout.connect(func():
		target.protections.erase(self)
	)
	$Area.body_entered.connect(func(body):
		body.be_damaged(damage)
	)

func recover_use():
	uses_left = min(uses_left + 1, uses)

func _physics_process(delta):
	var is_active = not $DashTime.is_stopped()
	if(uses_left > 0 and player_is_using_it and $InternalCooldown.is_stopped()):
		uses_left -= 1
		target.protections.push_back(self)
		$DashTime.start()
		$InternalCooldown.start()
		create_tween().tween_callback(self.recover_use).set_delay(cooldown_time)
		var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		create_tween().tween_property(
			target,
			"velocity",
			direction * (target.max_speed() + speed_bonus),
			dash_time / 2
		).set_trans(Tween.TRANS_BACK)

	$Area.monitoring = is_active
