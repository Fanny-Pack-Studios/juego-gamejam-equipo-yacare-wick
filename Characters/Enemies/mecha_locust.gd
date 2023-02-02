class_name MechaLocust
extends Enemy

var target: Node2D
@export var acceleration: float = 250
@export var max_speed: float = 250
@export var time_between_hits: float = 1
@export var damage_per_hit: float = 0.5
var attached_to_target = false
var attach_point: Vector2 = Vector2.ZERO
@onready var sound = $Sounds

func _ready():
	top_level = true

func sprites():
	return [$Polygon2D]

func _physics_process(delta):
	if(null == target):
		return

	if(attached_to_target):
		global_transform.origin = global_transform.origin.move_toward(
			target.global_transform.origin + attach_point,
			delta * max_speed
		)
		if (target.zap_things()):
			be_damaged(1)
			if !sound.is_playing():
				sound.play()
	else:
		var direction_to_target = global_transform.origin.direction_to(target.global_transform.origin)
		var target_velocity = direction_to_target * max_speed
		velocity = velocity.move_toward(target_velocity, delta * acceleration)

		move_and_slide()

func attack():
	target.take_damage(1, false)

func hit_with_spaceship(spaceship):
	if(not attached_to_target):
		$CollisionShape2D.set_deferred("disabled", true)
		attach_point = spaceship.random_attach_point()
		attached_to_target = true
		create_tween().tween_property(self, "scale", Vector2(0.7, 0.7), 1)
		create_tween().tween_property(self, "max_speed", 1000, 0.5)
		create_tween().tween_property(self, "acceleration", 2000, 0.5)
 
		$DamageTimer.wait_time = time_between_hits
		$DamageTimer.timeout.connect(self.attack)
		$DamageTimer.start()
