extends Area2D

func _ready():
	body_entered.connect(func(shoot): shoot.queue_free())
