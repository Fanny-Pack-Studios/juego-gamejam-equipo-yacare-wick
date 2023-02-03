extends Path2D

@export var delay_in_seconds: float = 1
@export var amount_of_enemies: float = 10
@export var delay_between_enemies_in_seconds: float = 2
@export var enemy_scene: PackedScene
@export var speed: float = 200
var followers: Array[PathFollow2D] = []

func _ready():
	top_level = true
	create_tween().tween_callback(self.start_spawning).set_delay(delay_in_seconds)
#	$EnemiesOnPathTrigger.screen_entered.connect(self.start_spawning)
	
func start_spawning():
	create_tween()\
		.set_loops(amount_of_enemies)\
		.tween_callback(self.spawn_one)\
		.set_delay(delay_between_enemies_in_seconds)

func _physics_process(delta):
	followers\
		.map(func(follow_path): follow_path.progress += speed * delta)

func spawn_one():
	var follow_path := PathFollow2D.new()
	follow_path.rotates = false
	followers.push_back(follow_path)
	add_child(follow_path)
	
	var enemy = enemy_scene.instantiate()
	enemy.set_moving_in_path(true)
	follow_path.add_child(enemy)
