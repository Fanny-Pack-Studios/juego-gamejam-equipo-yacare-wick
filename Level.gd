class_name Level
extends Node2D

const PilotsSelectionScreen = preload("res://Characters/Levels/PilotsSelectionScreen.tscn")
const BossMusic = preload("res://media/music/hard-prey-boss-music.mp3")
var boss_music_on = false

@export var beginning: Node2D
@export var end: Node2D
@export var travel_speed: float = 5.0
@onready var music = $Music

func _ready():
	$Travel/Beginning.top_level = true
	$Travel/End.top_level = true
	[$Walls, $Walls2].map(func (wall): wall.top_level = true)
	Party.board($Spaceship)

func length() -> float:
	return beginning.global_transform.origin.distance_to(end_point())

func _physics_process(delta):
	global_transform.origin = global_transform.origin.move_toward(
		end_point(),
		delta * travel_speed
	)
#	$ParallaxBackground.scroll_offset = $ParallaxBackground.scroll_offset + Vector2(0, -travel_speed) * delta
	$ParallaxBackground.scroll_offset = Vector2(0, distance_left())
	if distance_left() <= 200 && !boss_music_on:
		boss_music_on = true
		music.stop()
		music.stream = BossMusic
		music.play()

func distance_traveled() -> float:
	return length() - distance_left()

func distance_left():
	return global_transform.origin.distance_to(end_point())

func end_point() -> Vector2:
	return (beginning.global_transform.origin - end.global_transform.origin + Vector2(0, ProjectSettings.get_setting("display/window/size/viewport_height")))

func next_level():
	var tween = create_tween()
	tween.tween_property($CanvasLayer/FadeOut, "modulate", Color(0,0,0,1), 1)
	tween.tween_callback(func(): get_tree().change_scene_to_packed(PilotsSelectionScreen))
