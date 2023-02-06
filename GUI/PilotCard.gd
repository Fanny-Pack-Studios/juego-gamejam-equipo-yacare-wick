extends MarginContainer

var previous_position = null
var pilot

func set_pilot(new_pilot):
	pilot = Pilot.random()
	$HBoxContainer/Name.text = pilot.name
	$HBoxContainer/Images/Photo.texture = pilot.photo
	$HBoxContainer/Images/Power.texture = pilot.power().icon
	$HBoxContainer/Description.text = pilot.biography
	$HBoxContainer/Stats.text = pilot.stats_description()

func _ready():
	set_pilot(pilot)
	focus_entered.connect(func():
		self.increase_size()	
	)
	focus_exited.connect(func():
		self.decrease_size()
	)
	

func increase_size():
	if(previous_position == null):
		previous_position = position
	var tween = create_tween()
	var extra_size = 0.1
	tween.tween_property(self, "scale", Vector2.ONE + Vector2.ONE * extra_size, 0.2)
	tween.set_parallel().tween_property(self, "position", previous_position - size * extra_size / 2.0, 0.2)

func decrease_size():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0.2)
	tween.set_parallel().tween_property(self, "position", previous_position, 0.2)

