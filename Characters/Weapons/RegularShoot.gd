xtends Node2D

@export var speed: float = 10

func _ready():
	top_level = true

func velocity():
	return Vector2.DOWN * speed

func _physics_process(delta):
	translate(delta * velocity())

func _on_hitbox_body_entered(body):
	body.be_damaged(10)
	queue_free()
