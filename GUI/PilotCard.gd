extends MarginContainer

@export var photo: Texture2D
@export var pilot_name: String = ""
@export var biography: String = ""

var previous_position = null

func _ready():
	$VBoxContainer/Name.text = pilot_name
	$VBoxContainer/Powers/Photo.texture = photo
	$VBoxContainer/Description.text = biography
	focus_entered.connect(func():
		self.increase_size()	
	)
	focus_exited.connect(func():
		self.decrease_size()
	)

func increase_size():
	print("AA ", position)
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

func _on_gui_input(event: InputEvent):
	if(event.is_action_released("ui_accept")):
		next_level()

func next_level():
	get_tree().change_scene_to_packed(load("res://Characters/Levels/Nivel1.tscn"))
