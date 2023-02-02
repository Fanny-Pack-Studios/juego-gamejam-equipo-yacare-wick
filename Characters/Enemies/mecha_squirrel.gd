class_name MechaSquirrel
extends Enemy

var target_direction = null
@export var acceleration: float = 250
@export var max_speed: float = 1000
@export var wander_speed: float = 100
@onready var original_color = $SpriteAttacking/Sprite2.color
@onready var sound = $Sound

func _ready():
	top_level = true
	$SpriteWandering.visible = true
	$SpriteAttacking.visible = false
	velocity = Vector2.UP.rotated(rotation) * wander_speed


func sprites():
	return [$SpriteAttacking/Sprite1, $SpriteAttacking/Sprite2, $SpriteWandering]

func _physics_process(delta):
	move_and_slide()

func hit_with_spaceship(spaceship):
	spaceship.take_damage(15)
	queue_free()

func _on_detection_area_body_entered(body):
	var tween = create_tween()
	var time_to_jump = 0.2
	var target_position = body.global_transform.origin
	var own_position = global_transform.origin
	target_direction = own_position.direction_to(
		target_position + body.velocity * (own_position.distance_to(target_position) / max_speed)
	)
	tween.tween_property(
		self,
		"velocity",
		target_direction * max_speed,
		time_to_jump
	).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_ELASTIC)
#	tween.tween_callback(func(): 
#		self.target_direction = global_transform.origin.direction_to(body.global_transform.origin)
#	).set_delay(time_to_jump)
	create_tween().tween_property(
		self,
		"scale",
		Vector2(1.0, 2.0),
		3
	)
	$SpriteWandering.visible = false
	$SpriteAttacking.visible = true
	sound.play()
