extends Area2D

func _on_body_entered(body: Asteroid):
	body.vanish()
