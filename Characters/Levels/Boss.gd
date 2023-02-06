extends Enemy

const PilotsSelectionScreen = preload("res://Characters/Levels/PilotsSelectionScreen.tscn")
const MechaLochustSpawner = preload("res://Characters/Enemies/mecha_locust_spawner.tscn")
const MechaSquirrel = preload("res://Characters/Enemies/mecha_squirrel.tscn")

enum FightStatus { NotStarted, Starting, Started, Finished }

var fight_status = FightStatus.NotStarted
@onready var model_3d = $SubViewportContainer/SubViewport/GeneralFloralis
@onready var boss_health = %BossHealth
var inital_y_position

func _ready():
	super()
	boss_health.visible = false
	inital_y_position = position.y
	$DamageArea.body_entered.connect(func(body):
		body.take_damage(15)
		body.velocity = Vector2.UP * 1000
	)

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
		
		fight_strategy()

func fight_strategy():
	if(fight_status == FightStatus.Finished):
		return
	var width = ProjectSettings.get_setting("display/window/size/viewport_width")
	var target_x = randf_range(0.2, 0.7) * width
	await create_tween().set_loops(5).tween_property(self, "position:x", target_x, abs(position.x - target_x) * 5.0 / width).set_trans(Tween.TRANS_ELASTIC).finished
	await model_3d.spin_faster()
	await get_tree().create_timer(0.5).timeout

	await [spawn_lochusts, spawn_squirrels, jump].pick_random().call()

	await get_tree().create_timer(0.7).timeout
	await model_3d.stop_spinning_fast()
	await get_tree().create_timer(randf_range(0.3, 1.5)).timeout
	call_deferred("fight_strategy")

func jump():
	var previous_position_y = position.y
	await create_tween().tween_property(self, "position:y", position.y - 700.0, 3).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN).finished
	await create_tween().tween_property(self, "position:y", previous_position_y, 1.5).finished

func spawn_lochusts():
	var mecha_lochust_spawner = MechaLochustSpawner.instantiate()
	mecha_lochust_spawner.target_spaceship = get_node("%Spaceship")
	$SpawnPosition.add_child(mecha_lochust_spawner)
	mecha_lochust_spawner.position = Vector2.ZERO
	mecha_lochust_spawner.spawn_swarm()
	mecha_lochust_spawner.spawn_swarm()
	mecha_lochust_spawner.queue_free()
	await get_tree().create_timer(0.1).timeout

func spawn_squirrels():
	var amount: int = [1, 3, 5].pick_random()
	var squirrel_rotation = -15 * (amount / 2)
	for i in range(1, randi_range(2, 5)):
		var mecha_squirrel = MechaSquirrel.instantiate()
		mecha_squirrel.rotation_degrees = squirrel_rotation
		squirrel_rotation += 15
		$SpawnPosition.add_child(mecha_squirrel)
	await get_tree().create_timer(0.1).timeout

func sprites():
	return []

func _process(delta):
	if(fight_status == FightStatus.Started or fight_status == FightStatus.Finished):
		boss_health.value = current_health

func _killed():
	fight_status = FightStatus.Finished
	create_tween().tween_property(Engine, "time_scale", 0.5, 0.2)
	create_tween().set_loops().tween_property(self, "rotation_degrees", 359, 0.3).from(0.0)
	await create_tween().tween_property(self, "scale", Vector2.ZERO, 1.0).finished
	Engine.time_scale = 1
	$"../..".next_level()

func hit_with_spaceship(spaceship):
	if(fight_status == FightStatus.Started):
		spaceship.take_damage(10)

func be_damaged(damage):
	if(fight_status == FightStatus.Started):
		super(damage)
