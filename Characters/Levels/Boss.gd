extends Enemy

const PilotsSelectionScreen = preload("res://Characters/Levels/PilotsSelectionScreen.tscn")

enum FightStatus { NotStarted, Starting, Started }

var fight_status = FightStatus.NotStarted
@onready var boss_health = %BossHealth

func _ready():
	super()
	boss_health.visible = false

func start():
	if(fight_status == FightStatus.NotStarted):
		fight_status = FightStatus.Starting
		boss_health.value = 0.0
		boss_health.get_parent().position.y = 1100
		boss_health.visible = true
		boss_health.max_value = max_health
		await create_tween().tween_property(boss_health.get_parent(), "position:y", 1000.0, 1.0).from(1100.0).set_trans(Tween.TRANS_ELASTIC).finished
		await create_tween().tween_property(boss_health, "value", current_health, 2.0).from(0.0).set_trans(Tween.TRANS_LINEAR).finished
		fight_status = FightStatus.Started

func fight_strategy():
	pass

func sprites():
	return []

func _process(delta):
	if(fight_status == FightStatus.Started):
		boss_health.value = current_health

func _killed():
	$"../..".next_level()

func hit_with_spaceship(spaceship):
	if(fight_status == FightStatus.Started):
		spaceship.take_damage(10)

func be_damaged(damage):
	if(fight_status == FightStatus.Started):
		super(damage)
