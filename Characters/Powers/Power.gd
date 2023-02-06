class_name Power
extends Node2D

@export var power_name: String
@export var icon: Texture2D
var player_is_using_it: bool = false
var target: Spaceship
var pilot: Pilot

func be_configured_by_pilot(_pilot):
	pilot = _pilot

func bb_text():
	return ""
