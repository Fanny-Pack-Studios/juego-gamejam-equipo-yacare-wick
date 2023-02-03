extends Node

const Pilot = preload("res://Characters/Pilot/Pilot.gd")

var pilot: Pilot
var copilot: Pilot

func _ready():
	pilot = Pilot.random()
	copilot = Pilot.random()

func board(ship):
	ship.be_boarded(pilot, copilot)
