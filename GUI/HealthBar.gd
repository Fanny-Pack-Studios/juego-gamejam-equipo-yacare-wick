extends Control

@export var texture_progress_bar : TextureProgressBar
@export var player : Spaceship

func _process(delta):
	texture_progress_bar.max_value = player.MAX_HEALTH
	texture_progress_bar.min_value = 0
	texture_progress_bar.value = player.current_health
