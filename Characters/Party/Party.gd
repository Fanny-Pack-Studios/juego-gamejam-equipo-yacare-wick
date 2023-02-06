extends Node

const Pilot = preload("res://Characters/Pilot/Pilot.gd")

var pilot: Pilot
var copilot: Pilot
var instructor: Pilot
var past_instructors: Array	

func pop_pilots():
	var pilots = [pilot, copilot]
	pilot = null
	copilot = null
	return pilots

func pop_instructor():
	var _instructor = instructor
	instructor = null
	return instructor

func update():
	if(is_empty()):
		pilot = Pilot.random()
		copilot = Pilot.random()
		instructor = Pilot.random()
	else:
		var time_skip = randi_range(40, 50)
		[pilot, copilot, instructor].map(func(p): p._age += time_skip)
		pilot.has_piloted_before = true
		copilot.has_piloted_before = true
		past_instructors.push_back(instructor)

func is_empty():
	return null == pilot

func _ready():
	pilot = Pilot.random()
	copilot = Pilot.random()
	instructor = Pilot.random()

func board(ship: Spaceship):
	ship.be_boarded(pilot, copilot)

func assign_pilot(_pilot):
	pilot = _pilot
	
func assign_copilot(_copilot):
	copilot = _copilot

func assign_instructor(_instructor):
	instructor = _instructor

func assign_pilots(_pilot, _copilot):
	pilot = _pilot
	copilot = _copilot

func primary_power():
	return pilot.power()

func clean():
	pilot = null
	copilot = null
	instructor = null

func secondary_power():
	return copilot.power()
