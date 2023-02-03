extends Node

const Pilot = preload("res://Characters/Pilot/Pilot.gd")

var pilot: Pilot
var copilot: Pilot

func _ready():
	pilot = Pilot.random()
	copilot = Pilot.random()

func board(ship: Spaceship):
	ship.be_boarded(pilot, copilot)

func assign_pilots(_pilot, _copilot):
	pilot = _pilot
	copilot = _copilot

func primary_power():
	return pilot.power()

func secondary_power():
	return copilot.power()
