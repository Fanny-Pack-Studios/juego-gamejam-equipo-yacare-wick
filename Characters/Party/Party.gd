extends Node

const Pilot = preload("res://Characters/Pilot/Pilot.gd")
const FirstLevel = preload("res://Characters/Levels/Nivel1.tscn")

var pilot: Pilot
var copilot: Pilot
var instructor: Pilot
var past_instructors: Array	
var next_level: PackedScene
var current_level: PackedScene

func generate_new_pilots():
	var new_pilots = [Pilot.random(), Pilot.random(), Pilot.random()]
	new_pilots.map(func(p): p.instructors = past_instructors)
	return [pilot, copilot].map(func(p): return p if p != null else Pilot.random()) + new_pilots

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
		if(pilot.has_piloted_before):
			pilot = null
		else:
			pilot.has_piloted_before = true
		if(copilot.has_piloted_before):
			copilot = null
		else:
			copilot.has_piloted_before = true
		past_instructors.push_back(instructor)

func is_empty():
	return null == pilot

func _ready():
	next_level = FirstLevel
	current_level = next_level
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
