extends CharacterBody2D

var time_to_live_in_seconds: float = 1.0
var goes_through_enemies: bool = false
var fire_power: float = 1.0
var range_in_meters: float = 10.0
var initial_position: Vector2 = Vector2.ZERO

func _physics_process(_delta):
	move_and_slide()
	if(initial_position.distance_to(global_transform.origin) >= range_in_meters):
		queue_free()
 
func set_sprite(new_texture: Texture2D):
	$Sprite.texture = new_texture

	var image_bounding_box = new_texture.get_image().get_used_rect()
	var position = Vector2(image_bounding_box.get_center())
	$Hitbox/CollisionShape2D.transform.origin =\
		position - Vector2(image_bounding_box.size) * Vector2(0.5, 0)
	
	var rectangle_shape = RectangleShape2D.new()
	rectangle_shape.size = image_bounding_box.size
	$Hitbox/CollisionShape2D.shape = rectangle_shape
	

func set_initial_position(position):
	global_transform.origin = position
	initial_position = position

func _ready():
	$Hitbox.body_entered.connect(self._on_hitbox_body_entered)
	if(time_to_live_in_seconds > 0):
		$TimeToLive.timeout.connect(func (): queue_free())
		$TimeToLive.start(time_to_live_in_seconds)

func _on_hitbox_body_entered(body):
	body.be_damaged(fire_power)
	if(not goes_through_enemies):
		queue_free()
