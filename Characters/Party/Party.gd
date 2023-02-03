extends Node

const Pilot = preload("res://Characters/Pilot/Pilot.gd")

var current_offensive_pilot: Pilot
var current_defensive_pilot: Pilot
var current_mobility_pilot: Pilot

func _ready():
	pass

func board(ship):
	ship.be_boarded(
		current_offensive_pilot,
		current_defensive_pilot,
		current_mobility_pilot
	)
