class_name Level
extends Node2D

#Se cambio la escena de pilotos para la de condicion de victoria
#const PilotsSelectionScreen = preload("res://Characters/Levels/PilotsSelectionScreen.tscn")
const OutroScreen = preload("res://Characters/Levels/Outro/OutroScene.tscn")
const BossMusic = preload("res://media/music/hard-prey-boss-music.mp3")
var boss_music_on = false

@export var beginning: Node2D
@export var end: Node2D
@export var travel_speed: float = 5.0
@onready var music = $Music

func _ready():
	$Travel/Beginning.top_level = true
	$Travel/End.top_level = true
	[$Walls, $Walls2, $Walls3, $Walls4].map(func (wall): wall.top_level = true)
	Party.board($Spaceship)
	var level_config = find_child("LevelConfig", true)
	if(level_config):
		travel_speed = level_config.travel_speed
		end.global_position = beginning.global_position + Vector2(0, level_config.length)
		var planet = find_child("Planet", true)
		if(planet):
			planet.position = Vector2(0, end.position.y)
		var boss = find_child("Boss", true)
		if(boss):
			boss.position = Vector2(700, end.position.y - 100)

func length() -> float:
	return beginning.global_position.distance_to(end_point())

func _physics_process(delta):
	global_position = global_position.move_toward(
		end_point(),
		delta * travel_speed
	)
	$Camera2D.offset.y = position.y
#	$ParallaxBackground.scroll_offset = $ParallaxBackground.scroll_offset + Vector2(0, -travel_speed) * delta
	$ParallaxBackground.scroll_offset = Vector2(0, distance_left())
	if distance_left() <= 200 && !boss_music_on:
		boss_music_on = true
		var boss = find_child("Boss", true)
		if(boss):
			boss.start()
		music.stop()
		music.stream = BossMusic
		music.play()
		

func distance_traveled() -> float:
	return length() - distance_left()

func distance_left():
	return global_transform.origin.distance_to(end_point())

func end_point() -> Vector2:
	return (beginning.global_position - end.global_position + Vector2(0, ProjectSettings.get_setting("display/window/size/viewport_height")))

func next_level():
	var tween = create_tween()
	tween.tween_property($CanvasLayer/FadeOut, "modulate", Color(0,0,0,1), 1)
	tween.tween_callback(func(): get_tree().change_scene_to_packed(OutroScreen))
