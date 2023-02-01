class_name WeaponConfig

extends Resource

@export var shoots_per_second: float = 1.0
@export var shoot_speed: float = 20.0
@export var shoot_time_to_live_in_seconds: float = 10.0
@export var shoot_goes_through_enemies: bool = false
@export var fire_power: float = 1.0
@export var sprite: Texture2D = preload("res://addons/panku_console/res/pics/icons8-pi-32.png")
@export var range_in_meters: float = 10.0
@export var is_attached_to_parent: bool = false
