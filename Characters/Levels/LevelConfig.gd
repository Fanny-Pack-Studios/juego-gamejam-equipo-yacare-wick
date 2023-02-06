class_name LevelConfig
extends Node2D

@export var length: float
@export var travel_speed: float
@export_multiline var events_description: String = ""

var events: Array[Event] = []
var timer: Timer
var next_event: Event

func _duration() -> float:
	return length / travel_speed

func _ready():
	parse_events_description()
	timer = Timer.new()
	add_child(timer)
	timer.start(_duration())
	next_event = events.pop_front()

func parse_events_description():
	var event_lines = Array(events_description.strip_edges().split("\n"))
	event_lines.map(func (event_line: String):
		var event_params = event_line.split(",")
		var time_it_starts_at = event_params[0]
		var event_name = event_params[1].to_upper()
		var event
		match event_name:
			"ASTEROIDS", "ASTEROID":
				event = AsteroidShower.new()
			"SQUIRRELS", "SQUIRREL":
				event = Squirrels.new()
			"PATH":
				event = Event.new()
				var path_type = event_params[2]
				var enemy_type = event_params[3]
			"LOCHUSTS", "LOCHUST":
				event = Lochusts.new()
			_:
				assert(false, "el nombre no era ninguno de los de arriba")
		var intensity = event_params[2]
		event.intensity = intensity
		event.moment_it_starts_at = time_it_starts_at
		add_child(event)
		events.push_back(event)
	)

func time_passed() -> float:
	return timer.wait_time - timer.time_left 

func _physics_process(delta):
	if(null == next_event):
		return
	var time_of_next_event = next_event.moment_it_starts_at
	var _time_passed = time_passed()
	if(next_event.moment_it_starts_at <= time_passed()):
		var level = get_parent().get_parent()
		next_event.start(level)
		next_event = events.pop_front()
